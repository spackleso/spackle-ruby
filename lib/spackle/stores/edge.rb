require 'connection_pool'
require 'http'
require 'json'
require 'logger'

module Spackle
  class EdgeStore < BaseStore
    def initialize()
      @edge = ConnectionPool.new(size: 10, timeout: 5) do
        HTTP.persistent(Spackle.edge_base)
      end

      @api = ConnectionPool.new(size: 10, timeout: 5) do
        HTTP.persistent(Spackle.api_base)
      end
    end

    def get_customer_data(id)
      @edge.with do |http|
        response = http.auth("Bearer #{Spackle.api_key}").get(Spackle.edge_base + '/customers/' + id + '/state').flush

        if response.code != 200
          return fetch_state_from_api(id)
        end

        return JSON.parse(response.body)
      end
    end

    def fetch_state_from_api(id)
      Util.log_warn("Customer #{id} not found. Fetching from API...")
      @api.with do |http|
        response = http.auth("Bearer #{Spackle.api_key}").get(Spackle.api_base + '/customers/' + id + '/state').flush

        if response.code != 200
          raise SpackleError.new "Customer #{id} not found"
        end

        return JSON.parse(response.body)
      end
    end
  end
end
