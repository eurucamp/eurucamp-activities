# Overrides Rails' default handling of validation and other
# error messages for objects.
# Instead of displaying all errors as list above the form
# the errors are now displayed after each individual input
# element wrapped in a '<span/>'
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  error_class = 'validation-error'
  error_message_class = 'validation-error-message'

  if html_tag.match?(/<(input|textarea|select)[^>]+class=/)
    style_attribute = html_tag =~ /class=['"]/
    html_tag.insert(style_attribute + 7, "#{error_class} ")
  elsif html_tag.match?(/<(input|textarea|select)/)
    first_whitespace = html_tag =~ /\s/
    html_tag[first_whitespace] = " class='#{error_class}' "
  end

  if html_tag.match?(/<(label)/)
    html_tag
  elsif instance.error_message.is_a?(Array)
    %(#{html_tag} <span class="#{error_message_class}">#{instance.error_message.first}</span>).html_safe
  else
    %(#{html_tag} <span class="#{error_message_class}">#{instance.error_message}</span>).html_safe
  end
end
