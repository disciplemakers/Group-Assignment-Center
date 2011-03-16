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
              result << ["#{'---' * (i.level+1)}#{p.full_name}", "group-#{i.id}--person-#{p.id}"]
          end
        end
      end
      result.compact
    end
    result
  end
end
