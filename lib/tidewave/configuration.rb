# frozen_string_literal: true

require "logger"
require "tidewave/version"

module Tidewave
  class Configuration
    attr_accessor :logger, :allowed_origins, :localhost_only, :allowed_ips, :name, :version

    def initialize
      @logger = Logger.new(STDOUT)
      @allowed_origins = nil
      @localhost_only = true
      @allowed_ips = nil
      @name = "tidewave"
      @version = Tidewave::VERSION
    end
  end
end
