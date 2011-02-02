module LocationsHelper
  
  # Returns an li tag representing the location, including sub-lists
  # representing any children.
  def print_location(location)
    output = content_tag(:li, location.name, nil, false)
    if location.children.size > 0
      contents = ''
      location.children.each do |child|
        contents += print_location(child)
      end
      output += content_tag(:ul, contents, nil, false)
    end
    output
  end


  #<li>
   # <td><%= location.name %></td>
    #<td><%= link_to 'Show', location %></td>
    #<td><%= link_to 'Edit', edit_location_path(location) %></td>
    #<td><%= link_to 'Destroy', location, :confirm => 'Are you sure?', :method => :delete %></td>
  #</li>
      
  #end
    

end
