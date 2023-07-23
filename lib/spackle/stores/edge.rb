require 'net/http'
require 'json'
require 'logger'

module Spackle
  class EdgeStore < BaseStore
    def initialize()
      edge_uri = URI(Spackle.edge_base)
      @edge_http = Net::HTTP.new(edge_uri.host, edge_uri.port)
      @edge_http.use_ssl = true

      api_uri = URI(Spackle.api_base)
      @api_http = Net::HTTP.new(api_uri.host, api_uri.port)
      @api_http.use_ssl = true
    end

    def get_customer_data(id)
      request = Net::HTTP::Get.new(Spackle.edge_base + '/customers/' + id + '/state')
      request['Authorization'] = 'Bearer ' + Spackle.api_key
      request['X-Spackle-Schema-Version'] = Spackle.version.to_s

      response = @edge_http.request(request)
      if response.code != '200'
        return fetch_state_from_api(id)
      end

      JSON.parse(response.body)
    end

    def fetch_state_from_api(id)
      Util.log_warn("Customer #{id} not found. Fetching from API...")
      request = Net::HTTP::Get.new(Spackle.api_base + '/customers/' + id + '/state')
      request['Authorization'] = 'Bearer ' + Spackle.api_key
      request['X-Spackle-Schema-Version'] = Spackle.version.to_s

      response = @api_http.request(request)
      if response.code != '200'
        puts response.code
        puts response.body
        raise SpackleError.new "Customer #{id} not found"
      end

      JSON.parse(response.body)
    end
  end
end
