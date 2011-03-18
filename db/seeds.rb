# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

gender_constraints = GenderConstraint.create([{:constraint => 'Male'},
                                              {:constraint => 'Female'},
                                              {:constraint => 'Single Gender'}])                             

custom_fields = CustomField.create([
            {:name => 'Housing Assignment', :people_field => 'housing_assignment'},
            {:name => 'Small Group Assignment', :people_field => 'small_group_assignment'},
            {:name => 'Campus Group Room', :people_field => 'campus_group_room'}])                                  
