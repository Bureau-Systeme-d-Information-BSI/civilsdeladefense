# frozen_string_literal: true

# custom component for in place edit
module InPlaceEdit
  def in_place_edit(_wrapper_options)
    title = t('buttons.click_to_edit')
    klasses = %w[in-place-edit text-truncate]

    in_place_value = options[:in_place_value]
    return if in_place_value.blank?

    template.content_tag 'div', class: klasses, title: title do
      template.concat in_place_value
      template.concat options[:in_place_icon] if options[:in_place_icon]
    end
  end
end

# Register the component in Simple Form.
SimpleForm.include_component(InPlaceEdit)
