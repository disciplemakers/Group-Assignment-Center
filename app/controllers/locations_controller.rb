class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.xml
  def index
    Location.rebuild!
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    if @location.parent_id and not @location.parent
      flash[:notice] = "Error: This child thinks it has a parent but doesn't!"  
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  # GET /locations/1/new
  # GET /locations/1/new.xml
  def new
    @location = Location.new
    if params[:id]
      @parent = Location.find(params[:id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end
  
  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    respond_to do |format|
      if params[:commit] == 'Cancel'
        location = Location.find(params['location']['parent_id'])
        format.html { redirect_to(edit_location_path(location.root)) }
        format.xml  { head :ok }
      else
        @location = Location.new(params[:location])  
        if @location.save
          format.html { redirect_to(edit_location_path(@location.root), :notice => 'Location was successfully created.') }
          format.xml  { render :xml => @location, :status => :created, :location => @location }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])
    
    respond_to do |format|
      if params[:commit] == 'Cancel'
        format.html { redirect_to(edit_location_path(@location.root)) }
        format.xml  { head :ok }
      elsif @location.update_attributes(params[:location])
        format.html { redirect_to(edit_location_path(@location.root), :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    redirect_target = ''
    if @location.root?
      redirect_target = events_path
    else
      redirect_target = edit_location_path(@location.root)
    end
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(redirect_target) }
      format.xml  { head :ok }
    end
  end
  
  def disambiguate
    puts "in disambiguate method with #{request.method} request\n"
    puts "parent_id = #{params['location']['parent_id']}\n"
    
    if params['commit'] == 'Edit'
      redirect_to edit_location_path(params['location']['parent_id'])
    elsif params['commit'] == 'Clone'
      original_location = Location.find(params['location']['parent_id'].first)
      @parent = original_location.parent
      @location = original_location.clone
      name = "#{@location.name} (Clone)"
      @location.name = name
      @location.parent_id = nil
      render "new"
    elsif params['commit'] == 'New'
      if params.has_key?('location')
        if params['location'].has_key?('parent_id')
          redirect_to new_child_location_path(params['location']['parent_id'])
        elsif params['location'].has_key?('active_object_id')
          redirect_to new_child_location_path(params['location']['active_object_id'])
        else
          redirect_to new_location_path
        end
      else
        redirect_to new_location_path
      end
    elsif params['commit'] == 'Delete'
      # Assign a value for 'id' in the params hash because we're just going
      # to hand off to the destroy method. (We can't redirect because HTTP
      # redirects can only use GET, and that won't work with destroy.)
      request.params['id'] = params['location']['parent_id'].first      
      destroy
    else
      puts "commit didn't match anything!\n"
    end
  end
end
