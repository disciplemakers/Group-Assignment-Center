class GroupObserver < ActiveRecord::Observer
  observe :group
  
  def after_save(group)
    return unless group and group.custom_field
    
    label_text = group.build_custom_field_text
    label_field = group.custom_field.people_field
    
    group.people.each do |person|
      person.update_attribute(label_field, label_text)
      #person.write_custom_field_to_remote(RegonlineConnector.new(session[:account_id], session[:username], session[:password]),
      #                                    group.custom_field.name,
      #                                    label_text) #if RAILS_ENV == "production"
    end
  end
end
