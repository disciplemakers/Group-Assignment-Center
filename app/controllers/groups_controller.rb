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
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    puts "in edit method, with #{request.method} request\n"
    if request.post?
      group_id = request.request_parameters['parent_id']
      puts "group_id = #{group_id}\n"
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

    respond_to do |format|
      if @group.save
        @group.move_to_child_of(@parent)
        format.html { redirect_to(@group, :notice => 'Group was successfully created.') }
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

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
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
    puts "in destroy method with params[:id] = #{params[:id]}\n"
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
  def disambiguate
    #puts "in disambiguate method with #{request.method} request\n"
    #puts "parent_id = #{params['group']['parent_id']}\n"
    
    if params['commit'] == 'Edit'
      redirect_to edit_group_path(params[:id])
    elsif params['commit'] == 'New'
      if params.has_key?('group') and params['group'].has_key?('parent_id')
        redirect_to new_child_group_path(params['group']['parent_id'])
      else
        redirect_to new_group_path
      end
    elsif params['commit'] == 'Delete'
      # Assign a value for 'id' in the params hash because we're just going
      # to hand off to the destroy method. (We can't redirect because HTTP
      # redirects can only use GET, and that won't work with destroy.)
      request.params['id'] = params['group']['parent_id'].first      
      destroy
    else
      puts "commit didn't match anything!\n"
    end
  end

end
