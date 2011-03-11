require 'regonlineconnector'

class AssignmentsController < ApplicationController
  # GET /assignments
  # GET /assignments.xml
  def index
    @assignments = Assignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignments }
    end
  end

  # GET /assignments/1
  # GET /assignments/1.xml
  def show
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.xml
  def new
    @assignment = Assignment.new
    @event = Event.find(params[:event_id])
    @group = @event.group
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
    
    if params['commit'] == '<'
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
    else

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
    roc = RegonlineConnector.new(account_id, username, password)
    registrants = roc.report(event[:remote_report_id],
                             event[:remote_event_id],
                             '2/18/2010',
                             '2/18/2011',
                             'false')
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
                      "school"                 => registration['School'],
                      "graduation_year"        => registration['GraduationYear'],
                      "housing_assignment"     => registration['HousingAssignment'],
                      "small_group_assignment" => registration['SmallGroupAssignment'],
                      "campus_group_room"      => registration['CampusGroupRoom']}
        if !gac_registration.update_attributes(attributes)
          pp gac_registration.errors
        end        
      else
        gac_registration = Person.new(:confirmation_number    => registration['ConfirmationNumber'],
                                      :event_id               => event_id,
                                      :first_name             => registration['FirstName'],
                                      :last_name              => registration['LastName'],
                                      :gender                 => registration['Gender'],
                                      :registration_type      => registration['RegistrationType'],
                                      :school                 => registration['School'],
                                      :graduation_year        => registration['GraduationYear'],
                                      :housing_assignment     => registration['HousingAssignment'],
                                      :small_group_assignment => registration['SmallGroupAssignment'],
                                      :campus_group_room      => registration['CampusGroupRoom'])
        gac_registration.save
      end
    end
  end
end