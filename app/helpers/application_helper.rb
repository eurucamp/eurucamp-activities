module ApplicationHelper
  # Sets and formats document title
  #
  # @param [Mixed]
  # @param [String] Separator
  # @return [String] Title
  def title(t, separator = " | ")
    @title ||= []
    @title << t
    @title.flatten.compact.join(separator)
  end

  # Sets body classes
  #
  # @param [Mixed]
  # @return [String] CSS classes
  def body_class(c = nil)
    @body_class ||= [controller.controller_name]
    @body_class << c
    @body_class.flatten.compact.uniq.join(" ")
  end
end
