require 'spec_helper'

describe Group do
  before(:each) do
    @group = stub_model(Group,
                        :id                                => 3,
                        :name                              => "Name",
                        :capacity                          => 1,
                        :can_contain_people                => true,
                        :can_contain_groups                => false,
                        :location_id                       => 1,                        
                        :unique_membership                 => false,
                        :required_membership               => false,
                        :gender_constraint_id              => 1)
                    
  end
  
  it "is invalid without a name" do
    @group.name = nil
    @group.should be_invalid
  end
  
  it "is valid with a nil capacity" do
    @group.capacity = nil
    @group.should be_valid
  end
  
  it "is invalid with a non-numeric capacity" do
    @group.capacity = 'string'
    @group.should be_invalid
  end
  
  it "is invalid with a negative capacity" do
    @group.capacity = -1
    @group.should be_invalid
  end
  
  it "is invalid with a non-integer capacity" do
    @group.capacity = 1.5
    @group.should be_invalid
  end
  
  describe "that has at least one ancestor" do
    before(:each) do
      @group.parent_id = 2
      @parent = stub_model(Group,
                          :id                   => 2,
                          :parent_id            => 1,
                          :name                 => "Name",
                          :capacity             => 1,
                          :can_contain_people   => false,
                          :can_contain_groups   => true,
                          :location_id          => 1,                          
                          :unique_membership    => false,
                          :required_membership  => false,
                          :gender_constraint_id => 1)                          
                        
      @grandparent = stub_model(Group,
                                :id                   => 1,           
                                :name                 => "Name",
                                :capacity             => 1,
                                :can_contain_people   => false,
                                :can_contain_groups   => true,
                                :location_id          => 1,                              
                                :unique_membership    => false,
                                :required_membership  => false,
                                :gender_constraint_id => 1)

      Group.stub(:find).with(1).and_return(@grandparent)
      Group.stub(:find).with(2).and_return(@parent)
      @group.stub(:self_and_ancestors).with(no_args()).and_return([@group,
                                                                   @parent,
                                                                   @grandparent])                                        
    end
    
    it "is invalid if its parent can't contain groups" do
      @parent.can_contain_groups = false
      @group.should be_invalid
    end
    
    it "is valid if its parent can contain groups" do
      @group.should be_valid
    end
    
    describe "when required_membership scope is requested" do
      it "returns itself when required_membership is not set in itself or any ancestor" do
        @group.required_membership_scope.should == @group
      end
      
      it "returns itself when required_membership is set in itself" do
        @group.required_membership = true
        @group.required_membership_scope.should == @group
      end
      
      it "returns its parent when required_membership is set in its parent" do
        @parent.required_membership = true
        @group.required_membership_scope.should == @parent
      end
      
      it "returns its grandparent when required_membership is set in its grandparent" do
        @grandparent.required_membership = true
        @group.required_membership_scope.should == @grandparent
      end
    end

    describe "when unique_membership scope is requested" do
      it "returns itself when unique_membership is not set in itself or any ancestor" do
        @group.unique_membership_scope.should == @group
      end
      
      it "returns itself when unique_membership is set in itself" do
        @group.unique_membership = true
        @group.unique_membership_scope.should == @group
      end
      
      it "returns its parent when unique_membership is set in its parent" do
        @parent.unique_membership = true
        @group.unique_membership_scope.should == @parent
      end
      
      it "returns its grandparent when unique_membership is set in its grandparent" do
        @grandparent.unique_membership = true
        @group.unique_membership_scope.should == @grandparent
      end
    end

    describe "when custom field text is requested" do
      it "should return an empty string if it doesn't have a label field selected" do
        @group.label_field = nil
        @group.build_custom_field_text.should == ""
      end
      
      describe "and a label field is selected"
        before(:each) do
          @group.label_field = 'Custom Field Name'
          @group.label_text = 'Custom Field Text'
        end
        
        describe "and any ancestor that has a label field selected has the same field selected" do        
          it "should return only its own label text if no ancestors are set to prepend their label text" do
            @group.build_custom_field_text.should == @group.label_text
          end
          it "should return its parent's label text plus its own when the parent is set to prepend its label text"
          it "should return its grandparent's label text plus its parent's, plus its own when the parent and grandparent are set to prepend their label text"
          it "should return its grandparent's label text plus its own when the grandparent is set to prepend its label text but the parent is not"
        end
        
        it "should return only its own label text if its parent is set to prepend label text but the parent's label field does not match its own"
        it "should return its grandparent's label text plus its own if its grandparent's label field matches its own but its parent's does not"
        
        

        
        
        
        
    end    
    
  end
end
