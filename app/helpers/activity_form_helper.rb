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
      format = "#{type}_only".to_sym

      attributes = {
        type:        'text',
        class:       "#{type}-capture",
        placeholder: l(current_event.send(field), format: "nice_#{type}".to_sym),
        data:        { target: field, value: parse_date(model.send(field), format) }
      }

      if model.errors[field].any?
        attributes[:class] << ' validation-error'
      end

      attributes
    end

    def parse_date(d, format)
      l(d, format: format) rescue nil
    end

end
