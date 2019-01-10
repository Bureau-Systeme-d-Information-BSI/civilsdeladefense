module ApplicationHelper

  def time_ago_in_words_minimal(t)
    res = time_ago_in_words(t)
    res.split(" ").map do |x|
      case x
      when /min/
        "min"
      when /mois/
        "m"
      when /heure/
        "h"
      else
        x
      end
    end.join(" ")
  end

  def spinner
    content_tag 'div', class: 'indeterminate-circle mini text-primary' do
      concat '<svg version="1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24" height="24" viewBox="0 0 24 24">
          <path id="indeterminate" d="M12 3.25A8.75 8.75 0 1 1 3.25 12" stroke-width="2.5" stroke-linecap="square" fill="none" stroke="currentColor"/>
        </svg>'.html_safe
    end
  end

  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).build(role: args[:role])
    new_object.build_administrator
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: "btn btn-primary btn-link mt-2 mb-0 add_fields " + args[:class], data: {id: id, fields: fields.gsub("\n", "")})
  end
end
