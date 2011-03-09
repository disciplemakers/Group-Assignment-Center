require 'regonlineconnector'
require 'pp'

class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  def index
    Group.rebuild!
    
    @remote_events = remote_events(session[:account_id], session[:username], session[:password])
    create_events(@remote_events)

    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    if @event.remote_report_id
      @remote_registrants = remote_registrants(@event, session[:account_id], session[:username], session[:password])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end
  
  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @group = @event.group
    @location = @event.location
    @available_groups = Group.roots
    @available_groups -= [@group.root]
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(edit_event_path(@event), :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def remote_events(account_id, username, password)
    filter_hash = {'StatusId' => 1}
    roc = RegonlineConnector.new(account_id, username, password)
    #events = roc.events
    events = roc.filtered_events(filter_hash, "or", "false")
  end
  
  def location_from_event(event)
    if event['LocationName'].nil?
      return nil
    elsif Location.find(:first, :conditions => {:name => event['LocationName']})
      location = Location.find(:first, :conditions => {:name => event['LocationName']})
      location.id
    else
      location = Location.new(:name => event['LocationName'])
      location.save
      location.id
    end
  end
  
  def group_from_event(event)
    unless Group.find(:first, :conditions => {:name => event['Title'], :remote_event_id => event['ID']})
      group = Group.new(:name => event['Title'],
                        :can_contain_groups => true,
                        :remote_event_id => event['ID'],
                        :location => Location.find(:first,
                                                   :conditions => {:name => event['LocationName']}))
      group.save
      group.id
    else
      group = Group.find(:first, :conditions => {:name => event['Title'], :remote_event_id => event['ID']})
      group.id
    end
  end
  
  def status_from_event(event)
    unless Status.find(:first, :conditions => {:status => event['Status']})
      status = Status.new(:status => event['Status'])
      status.save
      status.id
    else
      status = Status.find(:first, :conditions => {:status => event['Status']})
      status.id
    end
  end
  
  def create_events(events)
    events.each do |id, event|
      if gac_event = Event.find(:first, :conditions => {:remote_event_id => event['ID']})
        attributes = {"remote_event_id" => event['ID'],
                      "location_id"     => location_from_event(event),
                      "group_id"        => group_from_event(event),
                      "start_date"      => event['StartDate'],
                      "end_date"        => event['EndDate'],
                      "status_id"       => status_from_event(event)}
        if !gac_event.update_attributes(attributes)
          pp gac_event.errors
        end        
      else
        gac_event = Event.new(:remote_event_id => event['ID'],
                              :location_id     => location_from_event(event),
                              :group_id        => group_from_event(event),
                              :start_date      => event['StartDate'],
                              :end_date        => event['EndDate'],
                              :status_id       => status_from_event(event))
        gac_event.save
      end
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
end
