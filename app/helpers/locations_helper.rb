module LocationsHelper
  
  # Returns an li tag representing the location, including sub-lists
  # representing any children.
  def print_location(location)
    # Print the location itself.
    output = content_tag(:li, nil, false) do
      link_to(location.name, location) + ' | ' +
      link_to('Edit', edit_location_path(location)) + ' | ' +
      link_to('New Child', new_child_path(location)) + ' | ' +
      link_to('Destroy', location, :confirm => 'Are you sure?', :method => :delete)
    end
             
    # Print any children in a sub-list.
    if location.children.size > 0
      contents = ''
      location.children.each do |child|
        contents += print_location(child)
      end
      output += content_tag(:ul, contents, nil, false)
    end
    output
  end    

end
