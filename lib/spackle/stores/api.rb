require 'faraday'
require "faraday/net_http_persistent"
require 'json'
require 'logger'

module Spackle
  class ApiStore < BaseStore
    def initialize()
      @api = Faraday.new(
        url: Spackle.api_base,
        headers: {
          'Authorization' => "Bearer #{Spackle.api_key}",
          'X-Spackle-Schema-Version' => Spackle.version.to_s,
        }
      ) do |faraday|
        faraday.adapter :net_http_persistent
      end
    end

    def get_customer_data(id)
      response = @api.get("/customers/#{id}/state")

      if response.status != 200
        raise SpackleError.new "Customer #{id} not found"
      end

      return JSON.parse(response.body)
    end
  end
end
