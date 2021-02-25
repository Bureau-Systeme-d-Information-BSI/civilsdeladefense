# frozen_string_literal: true

module AwesomeNestedHelper
  def grouped_nested_set_options(class_or_item, mover = nil)
    if class_or_item.is_a? Array
      items = class_or_item.select { |e| e.root? }
    else
      class_or_item = class_or_item.roots if class_or_item.respond_to?(:scope)
      items = Array(class_or_item)
    end
    result = []
    group = []
    items.each do |root|
      root.class.associate_parents(root.self_and_descendants).map { |i|
        if i.level == 0
          result.push [yield(i), []]
        elsif i.level == 1
          group = []
          group.push yield(i)
          group.push []
          result.push group
        elsif mover.nil? || mover.new_record? || mover.move_possible?(i)
          group[1].push [yield(i), i.primary_id]
        end
      }.compact
    end
    result
  end

  def nested_li(objects, &block)
    objects = objects.order(:lft) if objects.is_a? Class

    return "" if objects.empty?

    output = "<ul><li>"
    path = [nil]

    objects.each_with_index do |o, i|
      if o.parent_id != path.last
        # We are on a new level, did we descend or ascend?
        if path.include?(o.parent_id)
          # Remove the wrong trailing path elements
          while path.last != o.parent_id
            path.pop
            output << "</li></ul>"
          end
          output << "</li><li>"
        else
          path << o.parent_id
          output << "<ul><li>"
        end
      elsif i != 0
        output << "</li><li>"
      end
      output << capture(o, path.size - 1, &block)
    end

    output << "</li></ul>" * path.length
    output.html_safe
  end

  def sorted_nested_li(objects, order, &block)
    nested_li sort_list(objects, order), &block
  end

  private

  def sort_list(objects, order)
    objects = objects.order(:lft) if objects.is_a? Class

    # Partition the results
    children_of = {}
    objects.each do |o|
      children_of[o.parent_id] ||= []
      children_of[o.parent_id] << o
    end

    # Sort each sub-list individually
    children_of.each_value do |children|
      children.sort_by!(&order)
    end

    # Re-join them into a single list
    results = []
    recombine_lists(results, children_of, nil)

    results
  end

  def recombine_lists(results, children_of, parent_id)
    children_of[parent_id]&.each do |o|
      results << o
      recombine_lists(results, children_of, o.id)
    end
  end
end
