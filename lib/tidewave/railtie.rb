# frozen_string_literal: true

require "fast_mcp"
require "logger"
require "fileutils"
require "tidewave/configuration"
require "active_support/core_ext/class"

gem_tools_path = File.expand_path("tools/**/*.rb", __dir__)
Dir[gem_tools_path].each { |f| require f }

module Tidewave
  class Railtie < Rails::Railtie
    config.tidewave = Tidewave::Configuration.new

    initializer "tidewave.setup_mcp" do |app|
      # Prevent MCP server from being mounted if Rails is not running in development mode
      raise "For security reasons, Tidewave is only supported in development mode" unless Rails.env.development?

      config = app.config.tidewave

      # Set up MCP server with the host application using FastMcp.mount_in_rails
      FastMcp.mount_in_rails(
        app,
        name: config.name,
        version: config.version,
        path_prefix: '/tidewave',
        messages_route: 'messages',
        sse_route: 'mcp'
      ) do |server|
        # Register all tool classes that inherit from Tidewave::Tools::Base
        tool_classes = []
        ObjectSpace.each_object(Class) do |klass|
          if klass < Tidewave::Tools::Base && klass != Tidewave::Tools::Base
            tool_classes << klass
          end
        end
        
        tool_classes.each do |tool_class|
          server.register_tool(tool_class)
        end
      end
    end
  end
end
