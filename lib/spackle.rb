require 'logger'
require 'forwardable'

require 'spackle/customer'
require 'spackle/spackle_configuration'
require 'spackle/util'
require 'spackle/waiters'

require 'spackle/stores/base'
require 'spackle/stores/dynamodb'
require 'spackle/stores/file'
require 'spackle/stores/memory'

module Spackle
  @config = Spackle::SpackleConfiguration.new
  @client = nil

  LEVEL_DEBUG = Logger::DEBUG
  LEVEL_INFO = Logger::INFO
  LEVEL_WARN = Logger::WARN
  LEVEL_ERROR = Logger::ERROR

  class << self
    extend Forwardable

    attr_reader :config

    def_delegators :@config, :api_key, :api_key=
    def_delegators :@config, :api_base, :api_base=
    def_delegators :@config, :log_level, :log_level=
    def_delegators :@config, :store, :store=
    def_delegators :@config, :logger, :logger=
    def_delegators :@config, :version, :version=
  end

  def self.bootstrap
    Spackle.store
  end

  class SpackleError < StandardError
  end
end

Spackle.log_level = ENV["SPACKLE_LOG"] unless ENV["SPACKLE_LOG"].nil?
