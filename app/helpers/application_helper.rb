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
end
