require 'faraday'
require "faraday/net_http_persistent"
require 'json'
require 'logger'

module Spackle
  class EdgeStore < BaseStore
    def initialize()
      @edge = Faraday.new(
        url: Spackle.edge_base,
        headers: {
          'Authorization' => "Bearer #{Spackle.api_key}",
          'X-Spackle-Schema-Version' => Spackle.version.to_s,
        }
      ) do |faraday|
        faraday.adapter :net_http_persistent
      end

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
      response = @edge.get("/customers/#{id}/state")

      if response.status != 200
        return fetch_state_from_api(id)
      end

      return JSON.parse(response.body)
    end

    def fetch_state_from_api(id)
      Util.log_warn("Customer #{id} not found. Fetching from API...")
      response = @api.get(Spackle.api_base + "/customers/#{id}/state")

      if response.status != 200
        raise SpackleError.new "Customer #{id} not found"
      end

      return JSON.parse(response.body)
    end
  end
end
