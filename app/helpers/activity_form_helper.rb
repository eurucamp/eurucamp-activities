module ActivityFormHelper

  def fancy_datime_select(form, field, model)
    field = field.to_s
    haml_tag :fieldset, class: field.dasherize do
      haml_tag :div, class: 'select' do
        haml_concat form.datetime_select(field.to_sym, include_blank: true)
      end
      haml_tag :input, capture_attributes(field, model, 'date')
      haml_tag :input, capture_attributes(field, model, 'time')
    end
  end

  private

    def capture_attributes(field, model, type = 'date')
      field = field.to_sym

      attributes = {
        type:        'text',
        class:       "#{type}-capture",
        placeholder: l(current_event.send(field), format: "#{type}_only".to_sym),
        data:        { target: field }
      }

      if (value = model.send(field))
        attributes[:value] = l(value, format: "#{type}_only".to_sym)
      end

      if model.errors[field].any?
        attributes[:class] << ' validation-error'
      end

      attributes
    end

end
