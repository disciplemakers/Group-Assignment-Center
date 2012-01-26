module AssignmentsHelper
  def groups_with_people_options(group, selected_group)
    return "" if group.nil?
    options_for_select = []
    group.self_and_descendants.each do |i|
      count = i.people.count
      capacity = i.capacity
      status = (capacity.nil? ? (count <= 0 ? '' : " (#{count})") : " (#{count}/#{capacity})")
      selected = (i.id == selected_group ? " selected" : "")
      options_for_select << %(<option value="group-#{html_escape(i.id.to_s)}" class="group-option"#{selected}>#{'---' * (i.level)}#{i.name}#{status}</option>)
      i.people.each do |p|
          options_for_select << %(<option value="person-#{p.id}--group-#{i.id}" class="person-option">#{'----' * (i.level+1)}#{p.full_name_and_info}</option>)
      end
    end
    options_for_select.join("\n")
  end
end
