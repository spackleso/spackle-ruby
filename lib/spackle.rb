require 'forwardable'

require 'spackle/customer'
require 'spackle/dynamodb'
require 'spackle/spackle_configuration'

module Spackle
  @config = Spackle::SpackleConfiguration.new
  @client = nil

  class << self
    extend Forwardable

    attr_reader :config

    def_delegators :@config, :api_key, :api_key=
    def_delegators :@config, :api_base, :api_base=
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
