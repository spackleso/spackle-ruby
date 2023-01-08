require 'logger'
require 'forwardable'

require 'spackle/customer'
require 'spackle/dynamodb'
require 'spackle/spackle_configuration'
require 'spackle/util'

module Spackle
  @config = Spackle::SpackleConfiguration.new
  @client = nil

  LEVEL_DEBUG = Logger::DEBUG
  LEVEL_ERROR = Logger::ERROR
  LEVEL_INFO = Logger::INFO

  class << self
    extend Forwardable

    attr_reader :config

    def_delegators :@config, :api_key, :api_key=
    def_delegators :@config, :api_base, :api_base=
    def_delegators :@config, :log_level, :log_level=
    def_delegators :@config, :logger, :logger=
  end

  def self.client
    unless Spackle.api_key.nil?
      @client ||= Spackle::DynamoDB.new()
    end
  end

  def self.bootstrap
    self.client
    nil
  end
end

Spackle.log_level = ENV["SPACKLE_LOG"] unless ENV["SPACKLE_LOG"].nil?
