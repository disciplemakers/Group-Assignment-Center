require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AssignmentsHelper. For example:
#
# describe AssignmentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe AssignmentsHelper do
  before(:each) do
    @group = mock_model(Group,
                        :id                                => 1,
                        :name                              => "Parent",
                        :capacity                          => 1,
                        :people                            => [],
                        :can_contain_people                => false,
                        :can_contain_groups                => true,
                        :location_id                       => 1,
                        :comment                           => "MyText",
                        :unique_membership                 => false,
                        :required_membership               => false,
                        :gender_constraint_id              => 1,
                        :label_text                        => "Label Text",
                        :label_text_prepend_to_child_label => false,
                        :label_field                       => 1,
                        :level                             => 1)
    @people = [mock_model(Person,
                          :id                 => 1,
                          :full_name_and_info => "Full Name and Info 1"),
               mock_model(Person,
                          :id                 => 2,
                          :full_name_and_info => "Full Name and Info 2")]
    @descendant = mock_model(Group,
                             :id                                => 2,
                             :name                              => "Child",
                             :parent_id                         => 1,
                             :capacity                          => 2,
                             :people                            => @people,
                             :can_contain_people                => true,
                             :can_contain_groups                => false,
                             :location_id                       => 1,
                             :comment                           => "MyText",
                             :unique_membership                 => false,
                             :required_membership               => false,
                             :gender_constraint_id              => 1,
                             :label_text                        => "Label Text",
                             :label_text_prepend_to_child_label => false,
                             :label_field                       => 1,
                             :level                             => 2)
  end
  
  describe "when asking for groups with people select options" do
    describe "when given an object" do
      it "should return a string of html safe options" do
        @group.stub(:self_and_descendants).with(no_args()).and_return([@group, @descendant])
        @descendant.stub(:self_and_descendants).with(no_args()).and_return([@descendant])
        return_string = "<option value=\"group-1\" class=\"group-option\">---Parent (0/1)</option>\n" +
                        "<option value=\"group-2\" class=\"group-option\">------Child (2/2)</option>\n" +
                        "<option value=\"person-1--group-2\" class=\"person-option\">------------Full Name and Info 1</option>\n" +
                        "<option value=\"person-2--group-2\" class=\"person-option\">------------Full Name and Info 2</option>"

        groups_with_people_options(@group).should == return_string
      end
      it "should return an empty string when there are no options to present" do
        @group.stub(:self_and_descendants).with(no_args()).and_return([])
        
        groups_with_people_options(@group).should == ""
      end
    end
    
    describe "when given a nil object" do
      it "should return an empty string" do
        groups_with_people_options(nil).should == ""
      end
    end
  end  
end
