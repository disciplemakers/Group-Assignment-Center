require 'regonlineconnector'
require 'pp'

class AssignmentsController < ApplicationController

  # GET /assignments/new
  # GET /assignments/new.xml
  def new
    @assignment = Assignment.new
    @event = Event.find(params[:event_id])
    @sort_by_1 = (params['sort_by_1'].nil? ? "last_name, first_name" : params['sort_by_1'])
    @sort_by_2 = Person.sortable_fields[params['sort_by_2']]
    
    @sort_order = @sort_by_1
    @sort_order += ", #{params['sort_by_2']}" unless params['sort_by_2'].blank?
    
    # Check whether the form is being requested of a subgroup rather than
    # the group that corresponds to the whole event.
    if @drilldown_group_id = params[:drilldown_group_id]
      @group = @drilldown_group = Group.find(@drilldown_group_id)
    else
      @group = @drilldown_group = @event.group
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
    @sort_by_1 = (params['sort_by_1'].nil? ? "last_name, first_name" : params['sort_by_1'])
    @sort_by_2 = params['sort_by_2']
    
    @sort_order = @sort_by_1
    @sort_order += ", #{params['sort_by_2']}" unless params['sort_by_2'].blank?
    
    # Preserve our knowledge of what group we were looking at.
    if drilldown_group_id = params['drilldown_group_id'].to_i
      @drilldown_group = Group.find(drilldown_group_id)
    else
      @drilldown_group = @group
    end

    unless params[:left_side].nil?
      people = params[:left_side].select {|i| i =~ /^person-/}
      groups = params[:left_side].select {|i| i =~ /^group-/}
    end
    
    # The sort button
    if params['commit'] == 'Sort' or params['assign_action'] == "Sort"
      respond_to do |format|
        format.html { redirect_to(new_event_assignment_url(params[:event_id])) }
        format.js {render :template => "assignments/sort.js.rjs"}
      end 
    # The "assign" or "right-to-left" button
    elsif params['commit'] == '<--' or params['assign_action'] == '<--'
      if params[:assignment].nil? or params[:assignment]['person'].nil? or params[:assignment]['person'].length == 0 
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No people selected.') }
          format.js {render :template => "shared/error.js.rjs",
                            :locals => { :alert => "Assignment Error: No People Selected ..."}}
        end        
      elsif !groups.nil? and groups.length == 1
        @errors = []
        group_id = groups.first.gsub('group-', '').to_i
        params[:assignment]['person'].each do |p|
          assignment = Assignment.new(:group_id => group_id, :person_id => p)
          unless assignment.save
            @errors << assignment.errors.full_messages
          end
          # Update local db field
          group = Group.find(group_id)
          if !group.label_text.nil? and !group.label_field.nil?
            person = Person.find(p)
            label_text = group.build_custom_field_text
            unless person.update_attribute(group.custom_field.people_field, label_text)
              errors << person.errors
            end
            # write back label text to regonline
            person.write_custom_field_to_remote(
                RegonlineConnector.new(session[:account_id], session[:username], session[:password]),
                group.custom_field.name,
                label_text) if RAILS_ENV == "production"
          end
        end
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'Assignment was successfully created!!') }
          format.js
          format.xml  { head :ok }
        end        
      elsif !groups.nil? and groups.length > 1
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'More than one group on left selected.') }
          format.js {render :template => "shared/error.js.rjs",
                            :locals => { :alert => "Assignment Error: More than one group on left selected ..."}}
        end
      else # groups.length === 0
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No groups selected on left.') }
          format.js {render :template => "shared/error.js.rjs",
                            :locals => { :alert => "Assignment Error: No groups selected on left ..."}}
        end
      end
      
    # The "unassign" or "left-to-right" button
    elsif params['commit'] == '-->' or params['assign_action'] == '-->'
      if params[:left_side].nil? or people.nil?
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No people selected.') }
          format.js {render :template => "shared/error.js.rjs",
                            :locals => { :alert => "Assignment Error: No people selected for removal ..."}}
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
            person.write_custom_field_to_remote(
                RegonlineConnector.new(session[:account_id], session[:username], session[:password]),
                group.custom_field.name,
                '') if RAILS_ENV == "production"
          end
        end
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id])) }
          format.js
        end
      end
      
    # The "drill down" or "select" button
    elsif params['commit'] == 'Select Group' or params['assign_action'] == 'Select Group'
      if params[:left_side].nil? or groups.nil? or groups.length == 0
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'No group selected.') }
          format.js {render :template => "shared/error.js.rjs",
                            :locals => { :alert => "Error: No group selected ..."}}
        end
      elsif groups.length > 1
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id]), :notice => 'More than one group selected. Please select only one group.') }
          format.js {render :template => "shared/error.js.rjs",
                            :locals => { :alert => "Error: More than one group selected ..."}}
        end        
      else
        puts 'in final else of drill down action block'
        @drilldown_group = @group = Group.find(groups.first.gsub('group-', '').to_i)
        @event = Event.find(params[:event_id])
        respond_to do |format|
          format.html { redirect_to(new_event_assignment_url(params[:event_id], :drilldown_group_id => @drilldown_group.id)) }
          format.js
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
    end_date += (3600*24)
    roc = RegonlineConnector.new(account_id, username, password)
    registrants = roc.report(event[:remote_report_id],
                             event[:remote_event_id],
                             start_date.strftime("%m/%d/%Y"),
                             end_date.strftime("%m/%d/%Y"),
                             'true')
  end
  
  def save_remote_registrations(registrations, event_id)
    people = Person.find_all_by_event_id(event_id)
    remote_event_id = Event.find(event_id).remote_event_id
    registrations_hash = Hash.new
    custom_fields_hash = Hash.new
    people.each do |person|
      registrations_hash[person.confirmation_number] = {
        "confirmation_number"    => person.confirmation_number,
        "event_id"               => person.event_id.to_i,
        "first_name"             => person.first_name,
        "last_name"              => person.last_name,
        "gender"                 => person.gender,
        "registration_type"      => person.registration_type,
        "school"                 => person.school,
        "graduation_year"        => person.graduation_year.to_i,
        "housing_assignment"     => person.housing_assignment,
        "small_group_assignment" => person.small_group_assignment,
        "campus_group_room"      => person.campus_group_room
      }
      if person.groups.length > 0
        custom_fields_hash[person.confirmation_number] = Hash.new
        custom_fields_hash[person.confirmation_number]['custom_fields'] = Hash.new
        person.groups.collect do |pg|
          custom_fields_hash[person.confirmation_number]['custom_fields'][pg.custom_field.name] = 
                pg.build_custom_field_text if pg.custom_field
        end
      end
    end
    
    #print "\n\n#{remote_event_id}\n\n"
    #pp custom_fields_hash
    
    roc = RegonlineConnector.new(session[:account_id], session[:username], session[:password])
    updated_registrations = roc.update_registrations(
                                remote_event_id, 
                                custom_fields_hash) if RAILS_ENV == "production"
        
    registrations.each do |id, registration|
      if registration['RegistrationStatus'] == "Canceled"
        if registrations_hash[registration['ConfirmationNumber']]
          Person.find(:first,
                      :conditions => {:confirmation_number => registration['ConfirmationNumber']}).destroy
        end
        next
      end
      
      grad_year = (registration['GraduationYear'].to_i > 1900 ? registration['GraduationYear'].to_i : nil)
      person = Person.find(:first,
                           :conditions => {:confirmation_number => registration['ConfirmationNumber']})
      
      if !registrations_hash[registration['ConfirmationNumber']].nil?
        if custom_fields_hash[registration['ConfirmationNumber']].nil?
          housing_assignment = registration['HousingAssignment']
          small_group_assignment = registration['SmallGroupAssignment']
          campus_group_room = registration['CampusGroupRoom']
        else
          housing_assignment = custom_fields_hash[registration['ConfirmationNumber']]['custom_fields']['Housing Assignment'] ||
                               registration['HousingAssignment']
          small_group_assignment = custom_fields_hash[registration['ConfirmationNumber']]['custom_fields']['Small Group Assignment'] ||
                                   registration['SmallGroupAssignment']
          campus_group_room = custom_fields_hash[registration['ConfirmationNumber']]['custom_fields']['Campus Group Room'] || 
                              registration['CampusGroupRoom']
        end
        
        #roc = RegonlineConnector.new(session[:account_id], session[:username], session[:password])
        #if !housing_assignment.nil? and housing_assignment != registration['HousingAssignment']
        #    print "writing #{registration['FirstName']} #{registration['LastName']}'s housing_assignment=.:#{housing_assignment}:. back to regonline\n\n"
        #    # write back label text to regonline
        #    update_data_hash = {registration['ConfirmationNumber'] => {"custom_fields" => {"Housing Assignment" => housing_assignment}}}
        #    remote_event_id = Event.find(event_id.to_i).remote_event_id
        #    updated_registrations = roc.update_registrations(remote_event_id, update_data_hash) if RAILS_ENV == "production"
        #end
        #if !small_group_assignment.nil? and small_group_assignment != registration['SmallGroupAssignment']
        #    print "writing back #{registration['FirstName']} #{registration['LastName']}'s small_group_assignment=#{small_group_assignment} to regonline\n\n"
        #    # write back label text to regonline
        #    update_data_hash = {registration['ConfirmationNumber'] => {"custom_fields" => {"Small Group Assignment" => small_group_assignment}}}
        #    remote_event_id = Event.find(event_id.to_i).remote_event_id
        #    updated_registrations = roc.update_registrations(remote_event_id, update_data_hash) if RAILS_ENV == "production"          
        #end
        #if !campus_group_room.nil? and campus_group_room != registration['CampusGroupRoom']
        #    print "writing back #{registration['FirstName']} #{registration['LastName']}'s campus_group_room=#{campus_group_room} to regonline\n\n"
        #    # write back label text to regonline
        #    update_data_hash = {registration['ConfirmationNumber'] => {"custom_fields" => {"Campus Group Room" => campus_group_room}}}
        #    remote_event_id = Event.find(event_id.to_i).remote_event_id
        #    updated_registrations = roc.update_registrations(remote_event_id, update_data_hash) if RAILS_ENV == "production"         
        #end
        
        attributes = {"confirmation_number"    => registration['ConfirmationNumber'],
                      "event_id"               => event_id.to_i,
                      "first_name"             => registration['FirstName'],
                      "last_name"              => registration['LastName'],
                      "gender"                 => registration['Gender'],
                      "registration_type"      => registration['RegistrationType'],
                      "school"                 => registration['SchoolName'],
                      "graduation_year"        => grad_year,
                      "housing_assignment"     => housing_assignment,
                      "small_group_assignment" => small_group_assignment,
                      "campus_group_room"      => campus_group_room}
        if (attributes.sort != registrations_hash[registration['ConfirmationNumber']].sort)
          gac_registration = Person.find(:first,
                                         :conditions => {:confirmation_number => registration['ConfirmationNumber']})
          if !gac_registration.update_attributes(attributes)
            print "\n\n***********************ERROR SAVING ATTRIBUTES***********************************"
            pp attributes
            print "\n"
            pp gac_registration.errors
            print "\n\n"
          end
        end
      else
        gac_registration = Person.new(:confirmation_number    => registration['ConfirmationNumber'],
                                      :event_id               => event_id,
                                      :first_name             => registration['FirstName'],
                                      :last_name              => registration['LastName'],
                                      :gender                 => registration['Gender'],
                                      :registration_type      => registration['RegistrationType'],
                                      :school                 => registration['SchoolName'],
                                      :graduation_year        => grad_year,
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