require 'spec_helper'

describe "assignments/new.html.erb" do
  before(:each) do
    session[:username]   = 'joeuser'
    session[:password]   = 'password'
    session[:account_id] = '100'

    @location = stub_model(Location,
                           :id   => 1,
                           :name => "Location")    
    @event = stub_model(Event,
                        :id               => 1,
                        :remote_report_id => 654321,
                        :location_id      => 1,
                        :group_id         => 1)
    Event.stub(:find).with("1").and_return(@event)
    @event.stub(:location).with(no_args()).and_return(@location)
     
    @group = stub_model(Group,
                        :name                              => "Name",
                        :capacity                          => 1,
                        :can_contain_people                => false,
                        :can_contain_groups                => false,
                        :location_id                       => 1,
                        :comment                           => "MyText",
                        :unique_membership                 => false,
                        :required_membership               => false,
                        :gender_constraint_id              => 1,
                        :label_text                        => "Label Text",
                        :label_text_prepend_to_child_label => false,
                        :label_field                       => 1)
     Group.stub(:find).with(1, {:conditions=>nil}).and_return(@group)
     Group.stub(:find).with(0).and_return(nil)
     
     controller.stub(:remote_registrants).with(any_args).and_return([])
     
     assign(:assignment, stub_model(Assignment,
       :group_id => 1,
       :person_id => 1
      ).as_new_record)
  end
  
  #before(:each) do
  #  assign(:assignment, stub_model(Assignment,
  #    :group_id => 1,
  #    :person_id => 1
  #  ).as_new_record)
  #end

  it "renders new assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => assignments_path, :method => "post" do
      assert_select "input#assignment_group_id", :name => "assignment[group_id]"
      assert_select "input#assignment_person_id", :name => "assignment[person_id]"
    end
  end
end
