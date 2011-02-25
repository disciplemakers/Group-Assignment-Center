module ApplicationHelper
  
  # Returns an li tag representing the given object, including sub lists
  # representing any children.
  def print_tree(object)
    # Print the object itself.
    output = content_tag(:li, nil, false) do
      link_to(object.name, object) + ' | ' +
      link_to('Edit', url_for(object)+"/edit") + ' | ' +
      link_to('New Child', url_for(object)+"/new") + ' | ' +
      link_to('Destroy', object, :confirm => 'Are you sure?', :method => :delete)
    end
             
    # Print any children in a sub-list.
    if object.children.size > 0
      contents = ''
      object.children.each do |child|
        contents += print_tree(child)
      end
      output += content_tag(:ul, contents, {:class => "sub"}, false)
    end
    output
  end 
  
end
