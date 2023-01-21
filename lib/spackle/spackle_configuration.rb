require 'logger'

module Spackle
  class SpackleConfiguration
    attr_accessor :api_key
    attr_accessor :api_base
    attr_accessor :log_level
    attr_reader   :logger
    attr_reader   :version

    def initialize
      @api_base = 'https://api.spackle.so'
      @log_level = Logger::INFO
      @logger = Logger.new(STDOUT, level: @log_level)
      @version = 1
    end

    def log_level=(level)
      @log_level = level
      @logger.level = level
    end
  end
end
