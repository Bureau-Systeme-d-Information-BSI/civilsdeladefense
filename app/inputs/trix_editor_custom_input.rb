class TrixEditorCustomInput < Trix::SimpleForm::TrixEditorInput
  def input(_wrapper_options)
    editor_tag = template.content_tag("trix-editor", "", editor_options)
    hidden_field = @builder.hidden_field(attribute_name, input_html_options)
    template.content_tag(
      "div",
      hidden_field + editor_tag + limit_hint_div,
      class: "trix-editor-wrapper",
      data: {
        controller: "trix-editor",
        "trix-editor-limit-value": maximum_length
      }
    )
  end

  private

  def editor_options
    {
      input: input_class,
      class: "trix-content",
      data: {
        action: "trix-change->trix-editor#limit",
        "trix-editor-target": "editor"
      }
    }
  end

  def limit_hint_div
    counter = template.content_tag(
      "span",
      "-",
      data: {
        "trix-editor-target": "counter"
      }
    )
    maximum = "/#{maximum_length}"
    template.content_tag(
      "div",
      counter + maximum,
      class: "mx-3 mb-2 text-muted"
    )
  end

  def maximum_length
    validator = find_validator(:html_length)
    return unless validator

    validator.options[:maximum]
  end
end
