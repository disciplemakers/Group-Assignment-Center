module AssignmentsHelper
  def groups_with_people_options(class_or_item, mover = nil)
    class_or_item = class_or_item.roots if class_or_item.is_a?(Class)
    items = Array(class_or_item)
    result = []
    items.each do |root|
      root.self_and_descendants.map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          result << ["#{'---' * (i.level)}#{i.name}", "group-#{i.id}"]
          i.people.each do |p|
              result << ["#{'---' * (i.level+1)}#{p.full_name_and_info}",
                         "person-#{p.id}--group-#{i.id}"]
          end
        end
      end
      result.compact
    end
    result
  end
  
  def groups_with_people_options_with_style(class_or_item, mover = nil)
    class_or_item = class_or_item.roots if class_or_item.is_a?(Class)
    items = Array(class_or_item)
    options_for_select = []
    items.each do |root|
      root.self_and_descendants.map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          count = i.people.count
          capacity = i.capacity
          status = (capacity.nil? ? (count <= 0 ? '' : " (#{count})") : " (#{count}/#{capacity})")   
          options_for_select << %(<option value="group-#{html_escape(i.id.to_s)}" class="group-option">#{'---' * (i.level)}#{i.name}#{status}</option>)
          i.people.each do |p|
              options_for_select << %(<option value="person-#{p.id}--group-#{i.id}" class="person-option">#{'----' * (i.level+1)}#{p.full_name_and_info}</option>)
          end
        end
      end
    end
    options_for_select.join("\n")
  end
end
