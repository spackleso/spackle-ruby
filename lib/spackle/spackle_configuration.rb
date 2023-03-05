require 'logger'

module Spackle
  class SpackleConfiguration
    attr_accessor :api_key
    attr_accessor :api_base
    attr_reader   :logger
    attr_reader   :version

    def initialize
      @api_base = 'https://api.spackle.so/v1'
      @log_level = Logger::WARN
      @logger = Logger.new(STDOUT, level: @log_level)
      @version = 1
      @store = nil
    end

    def log_level()
      @log_level
    end

    def log_level=(level)
      @log_level = level
      @logger.level = level
    end

    def store()
      if @store == nil
        @store = DynamoDBStore.new
      end
      @store
    end

    def store=(store)
      @store = store
    end
  end
end
