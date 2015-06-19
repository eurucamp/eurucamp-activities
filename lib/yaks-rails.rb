require 'rails'
require 'yaks'

module Yaks
  def self.global_config
    @global_config ||= ::Yaks.new
  end

  class << self
    attr_writer :global_config
  end

  def self.configure(&block)
    @global_config = ::Yaks.new(&block)
  end

  module Rails
    module ControllerAdditions
      def yaks(object, opts = {})
        status = opts.delete(:status) || :ok
        runner = Yaks.global_config.runner(object, {env: env}.merge(opts))
        render text: runner.call,
          content_type: runner.media_type,
          status: status
      end
    end
  end
end
