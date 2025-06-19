# frozen_string_literal: true

require "tidewave/version"

module Tidewave
end

# Only load the railtie if Rails is available
if defined?(Rails)
  require "tidewave/railtie"
end
