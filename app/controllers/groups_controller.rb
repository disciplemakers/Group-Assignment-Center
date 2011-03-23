class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.xml
  def index
    Group.rebuild!
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])
    
    @root = @group.root
    @event = Event.find(:first, :conditions => {:group_id => @root})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  # GET /groups/1/new
  # GET /groups/1/new.xml
  def new
    @group = Group.new
    if params[:id]
      @parent = Group.find(params[:id])
      unless @parent.can_contain_groups
        event = Event.find_by_group_id(@parent.root)
        redirect_to(edit_event_path(event),
                    :notice => "Selected group cannot contain groups.")
        return
      end
    end
    
    respond_to do |format|     
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    if request.post?
      group_id = request.request_parameters['parent_id']
    else
      group_id = params[:id]
    end
    @group = Group.find(group_id)
  end


  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @parent = Group.find(params[:parent_id].to_i)

    @root = @parent.root
    @event = Event.find(:first, :conditions => {:group_id => @root})

    respond_to do |format|
      if params[:commit] == 'Cancel'
        format.html { redirect_to(edit_event_path(@event)) }
        format.xml  { head :ok }
      elsif @group.save
        @group.move_to_child_of(@parent)
        format.html { redirect_to(edit_event_path(@event), :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])
    
    @root = @group.root
    @event = Event.find(:first, :conditions => {:group_id => @root})

    respond_to do |format|
      if params[:commit] == 'Cancel'
        format.html { redirect_to(edit_event_path(@event)) }
        format.xml  { head :ok }
      elsif @group.update_attributes(params[:group])
        format.html { redirect_to(edit_event_path(@event), :notice => "#{@group.name} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    
    @root = @group.root
    @event = Event.find(:first, :conditions => {:group_id => @root})
    
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(edit_event_path(@event)) }
      format.xml  { head :ok }
    end
  end
  
  def disambiguate
    #puts "in disambiguate method with #{request.method} request\n"
    #puts "parent_id = #{params['group']['parent_id']}\n"
    
    if params['commit'] == 'Edit'
      redirect_to edit_group_path(params['group']['parent_id'])
    elsif params['commit'] == 'New'
      if params.has_key?('group')
        if params['group'].has_key?('parent_id')
          redirect_to new_child_group_path(params['group']['parent_id'])
        elsif params['group'].has_key?('active_object_id')
          redirect_to new_child_group_path(params['group']['active_object_id'])
        else
          redirect_to new_group_path
        end
      else
        redirect_to new_group_path
      end
    elsif params['commit'] == 'Delete'
      # Assign a value for 'id' in the params hash because we're just going
      # to hand off to the destroy method. (We can't redirect because HTTP
      # redirects can only use GET, and that won't work with destroy.)
      request.params['id'] = params['group']['parent_id'].first      
      destroy
    elsif params['commit'] == '<'
      if params.has_key?('group')
        if params['group'].has_key?('parent_id')
          destination = params['group']['parent_id'].first
        elsif params['group'].has_key?('active_object_id')
          destination = params['group']['active_object_id'].first
        else
          redirect_to new_group_path
        end
        
        if params['group'].has_key?('location')
          locations_to_be_copied = params['group']['location']
          locations_to_be_copied.each do |location|
            clone_location_branch(Location.find(location), destination)
          end
        end
        
        if params['group'].has_key?('id')
          groups_to_be_copied = params['group']['id']
          groups_to_be_copied.each do |group|
            clone_group_branch(Group.find(group), destination)
          end
        end
        
      else
        redirect_to new_group_path
      end
      
      groups = params['group']['id']
      locations = params['group']['location_id']
      
      redirect_to(edit_event_path(params['group']['active_object_id']),
                  :notice => notice)
    else
      puts "commit didn't match anything!\n"
    end
  end
  
  def clone_group_branch(group, destination)
    clone = group.clone
    clone.parent_id = nil
    clone.save
    clone.move_to_child_of(destination)
      
    if !group.leaf?
      group.children.each do |child|
        clone_group_branch(child, clone)
      end
    end
  end
  
  def clone_location_branch(location, destination_group)
    group = group_from_location(location)
    group.save
    group.move_to_child_of(destination_group)
    
    if !location.leaf?
      location.children.each do |child_location|
        clone_location_branch(child_location, group)
      end
    end
  end
  
  def group_from_location(location)
    group = Group.new(:name     => location.name,
                      :capacity => location.capacity,
                      :location_id => location.id,
                      :comment  => location.comment)
  end

end
