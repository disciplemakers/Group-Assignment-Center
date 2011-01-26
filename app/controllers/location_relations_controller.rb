class LocationRelationsController < ApplicationController
  # GET /location_relations
  # GET /location_relations.xml
  def index
    @location_relations = LocationRelation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @location_relations }
    end
  end

  # GET /location_relations/1
  # GET /location_relations/1.xml
  def show
    @location_relation = LocationRelation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location_relation }
    end
  end

  # GET /location_relations/new
  # GET /location_relations/new.xml
  def new
    @location_relation = LocationRelation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location_relation }
    end
  end

  # GET /location_relations/1/edit
  def edit
    @location_relation = LocationRelation.find(params[:id])
  end

  # POST /location_relations
  # POST /location_relations.xml
  def create
    @location_relation = LocationRelation.new(params[:location_relation])

    respond_to do |format|
      if @location_relation.save
        format.html { redirect_to(@location_relation, :notice => 'Location relation was successfully created.') }
        format.xml  { render :xml => @location_relation, :status => :created, :location => @location_relation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /location_relations/1
  # PUT /location_relations/1.xml
  def update
    @location_relation = LocationRelation.find(params[:id])

    respond_to do |format|
      if @location_relation.update_attributes(params[:location_relation])
        format.html { redirect_to(@location_relation, :notice => 'Location relation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /location_relations/1
  # DELETE /location_relations/1.xml
  def destroy
    @location_relation = LocationRelation.find(params[:id])
    @location_relation.destroy

    respond_to do |format|
      format.html { redirect_to(location_relations_url) }
      format.xml  { head :ok }
    end
  end
end
