require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  before(:each) do
    @descendants = [mock_model(Group, :id       => 2,
                                      :name     => "Child 1",
                                      :children => []),
                    mock_model(Group, :id       => 3,
                                      :name     => "Child 2",
                                      :children => [])]
    @group = mock_model(Group, :id       => 1,
                               :name     => "Parent",
                               :children => @descendants)
    @empty = mock_model(Group, :id => 4,
                               :name => nil)
  end
  
  it "should return a tree with valid input" do
    printed_tree = "<li><a href=\"/groups/1\">Parent</a> " +
                   "| <a href=\"/groups/1/edit\">Edit</a> " +
                   "| <a href=\"/groups/1/new\">New Child</a> " +
                   "| <a href=\"/groups/1\" data-confirm=\"Are you sure?\" " + 
                   "data-method=\"delete\" rel=\"nofollow\">Destroy</a></li>" +
                   "<ul class=\"sub\"><li><a href=\"/groups/2\">Child 1</a> " +
                   "| <a href=\"/groups/2/edit\">Edit</a> " +
                   "| <a href=\"/groups/2/new\">New Child</a> " +
                   "| <a href=\"/groups/2\" data-confirm=\"Are you sure?\" " + 
                   "data-method=\"delete\" rel=\"nofollow\">Destroy</a></li>" +
                   "<li><a href=\"/groups/3\">Child 2</a> " +
                   "| <a href=\"/groups/3/edit\">Edit</a> " +
                   "| <a href=\"/groups/3/new\">New Child</a> " +
                   "| <a href=\"/groups/3\" data-confirm=\"Are you sure?\" " + 
                   "data-method=\"delete\" rel=\"nofollow\">Destroy</a></li></ul>"
    print_tree(@group).should == printed_tree
  end
  it "should return an empty string if given an object with nothing to print" do
    print_tree(@empty).should == ""
  end
  it "should return an empty string when given a nil object" do
    print_tree(nil).should == ""
  end
end