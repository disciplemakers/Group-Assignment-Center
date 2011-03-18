require 'regonlineconnector'

class AssignmentsController < ApplicationController

  # GET /assignments/new
  # GET /assignments/new.xml
  def new
    @assignment = Assignment.new
    @event = Event.find(params[:event_id])
    
    # Check whether the form is being requested of a subgroup rather than
    # the group that corresponds to the whole event.
    if drilldown_group_id = params[:drilldown_group_id]
      @group = Group.find(drilldown_group_id)
    else
      @group = @event.group
    end
    
    if @event.remote_report_id
      @remote_registrants = remote_registrants(@event, session[:account_id], session[:username], session[:password])
      save_remote_registrations(@remote_registrants, params[:event_id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id])
    @event = Event.find(params[:event_id])
    @group = @event.group
    if @event.remote_report_id
      @remote_registrants = remote_registrants(@event, session[:account_id], session[:username], session[:password])
    end

  end

  # POST /assignments
  # POST /assignments.xml
  def create
    @event = Event.find(params[:event_id])
    @group = @event.group
    
    unless params[:left_side].nil?
      people = params[:left_side].select {|i| i =~ /^person-/}
      groups = params[:left_side].select {|i| i =~ /^group-/}
    end
    
    # The "assign" or "right-to-left" button
    if params['commit'] == '<--'
      if params[:assignment].nil? or params[:assignment]['person'].nil? or params[:assignment]['person'].length == 0 
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No people selected.') }
        end        
      elsif !groups.nil? and groups.length == 1
        errors = []
        group_id = groups.first.gsub('group-', '').to_i
        params[:assignment]['person'].each do |p|
          assignment = Assignment.new(:group_id => group_id, :person_id => p)
          unless assignment.save
            errors << assignment.errors
          end
          # Update local db field
          group = Group.find(group_id)
          if !group.label_text.nil? and !group.label_field.nil?
            person = Person.find(p)
            label_text = build_custom_field_text(group)
            unless person.update_attribute(group.custom_field.people_field, label_text)
              errors << person.errors
            end
            # write back label text to regonline
            roc = RegonlineConnector.new(session[:account_id], session[:username], session[:password])
            update_data_hash = {person.confirmation_number => {"custom_fields" => {group.custom_field.name => label_text}}}
            event_id = @event.remote_event_id
            updated_registrations = roc.update_registrations(event_id, update_data_hash)
          end
        end
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'Assignment was successfully created!!') }
          format.xml  { head :ok }
        end        
      elsif !groups.nil? and groups.length > 1
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'More than one group on left selected.') }
        end
      else # groups.length === 0
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No groups selected on left.') }
        end
      end
      
    # The "unassign" or "left-to-right" button
    elsif params['commit'] == '-->'
      if params[:left_side].nil? or people.nil?
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No people selected.') }
        end
      else
        people.each do |p|
          match = p.scan(/person-(\d+)--group-(\d+)/)[0]
          # Since we already limited "people" to options that have a person ID,
          # there should be no danger that match would be nil.
          person_id = match[0]
          group_id = match[1]
          Assignment.destroy_all(["person_id = ? AND group_id = ?", person_id, group_id])
          # Clear local db field
          group = Group.find(group_id)
          if !group.label_text.nil? and !group.label_field.nil?
            person = Person.find(person_id)
            unless person.update_attribute(group.custom_field.people_field, nil)
              errors << person.errors
            end
            # write back label text to regonline
            roc = RegonlineConnector.new(session[:account_id], session[:username], session[:password])
            update_data_hash = {person.confirmation_number => {"custom_fields" => {group.custom_field.name => ''}}}
            event_id = @event.remote_event_id
            updated_registrations = roc.update_registrations(event_id, update_data_hash)
          end
        end
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id])) }
        end
      end
      
    # The "drill down" or "select" button
    elsif params['commit'] == 'Select Group'
      if params[:left_side].nil? or groups.nil? or groups.length == 0
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No group selected.') }
        end
      elsif groups.length > 1
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'More than one group selected. Please select only one group.') }
        end        
      else
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id], :drilldown_group_id => groups.first.gsub('group-', '').to_i)) }
        end
      end                  
    end
    
    #respond_to do |format|
    #  if @assignment.save
    #    format.html { redirect_to(@assignment, :notice => 'Assignment was successfully created.') }
    #    format.xml  { render :xml => @assignment, :status => :created, :location => @assignment }
    #  else
    #    format.html { render :action => "new" }
    #    format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # PUT /assignments/1
  # PUT /assignments/1.xml
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        format.html { redirect_to(@assignment, :notice => 'Assignment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to(event_assignments_url) }
      format.xml  { head :ok }
    end
  end
  
  def remote_registrants(event, account_id, username, password)
    end_date = Time.now
    year_in_seconds = 31536000
    start_date = end_date - year_in_seconds
    roc = RegonlineConnector.new(account_id, username, password)
    registrants = roc.report(event[:remote_report_id],
                             event[:remote_event_id],
                             start_date.strftime("%m/%d/%Y"),
                             end_date.strftime("%m/%d/%Y"),
                             'true')
  end
  
  def build_custom_field_text(group)
    text_array = []
    ancestry = group.self_and_ancestors
    ancestry.each do |g|
      text_array << g.label_text if ((g.label_field = group.label_field) and g.label_text_prepend_to_child_label) or (g == group)
    end
    #text_array << group.label_text
    text_array.compact
    text = text_array.join(" ")
  end
  
  def save_remote_registrations(registrations, event_id)
    registrations.each do |id, registration|
      if gac_registration = Person.find(:first,
                                        :conditions => {:confirmation_number => registration['ConfirmationNumber']})
        attributes = {"confirmation_number"    => registration['ConfirmationNumber'],
                      "event_id"               => event_id,
                      "first_name"             => registration['FirstName'],
                      "last_name"              => registration['LastName'],
                      "gender"                 => registration['Gender'],
                      "registration_type"      => registration['RegistrationType'],
                      "school"                 => registration['SchoolName'],
                      "graduation_year"        => registration['GraduationYear'],
                      "housing_assignment"     => registration['HousingAssignment'],
                      "small_group_assignment" => registration['SmallGroupAssignment'],
                      "campus_group_room"      => registration['CampusGroupRoom']}
        if !gac_registration.update_attributes(attributes)
          print "\n\n***********************ERROR SAVING ATTRIBUTES***********************************"
          pp attributes
          print "\n"
          pp gac_registration.errors
          print "\n\n"
        end        
      else
        gac_registration = Person.new(:confirmation_number    => registration['ConfirmationNumber'],
                                      :event_id               => event_id,
                                      :first_name             => registration['FirstName'],
                                      :last_name              => registration['LastName'],
                                      :gender                 => registration['Gender'],
                                      :registration_type      => registration['RegistrationType'],
                                      :school                 => registration['SchoolName'],
                                      :graduation_year        => registration['GraduationYear'],
                                      :housing_assignment     => registration['HousingAssignment'],
                                      :small_group_assignment => registration['SmallGroupAssignment'],
                                      :campus_group_room      => registration['CampusGroupRoom'])
        
        if !gac_registration.save
          print "\n\n***********************ERROR SAVING REGISTRATION***********************************"
          pp gac_registration
          print "\n"
          pp gac_registration.errors
          print "\n\n"
        end        
      end
    end
  end
end