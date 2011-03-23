require 'spec_helper'

describe "assignments/edit.html.erb" do
  before(:each) do
    @group = stub_model(Group, :id => 1, 
                        :required_membership_scope => self,
                        :self_and_descendants => [self],
                        :people => [stub_model(Person)],
                        :capacity => 4)

    @assignment = assign(:assignment, stub_model(Assignment,
      :group_id => 1,
      :person_id => 1,
      :group => @group
    ))
    @event = stub_model(Event, :event_id => 1)
  end

  it "renders the edit assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => edit_event_assignment_path(@event, @assignment), :method => "post" do
      assert_select "select#_left_side", :name => "[left_side[]]"
      assert_select "select#assignment_person", :name => "assignment[person][]"
    end
  end
end
