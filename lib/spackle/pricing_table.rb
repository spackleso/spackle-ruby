module Spackle
  class PricingTable
    def self.retrieve(id)
      @api = Faraday.new(
        url: Spackle.api_base,
        headers: {
          'Authorization' => "Bearer #{Spackle.api_key}",
        }
      ) do |faraday|
        faraday.adapter :net_http_persistent
      end

      response = @api.get(Spackle.api_base + "/pricing_tables/#{id}")

      if response.status != 200
        raise SpackleError.new "Pricing table #{id} not found"
      end

      return JSON.parse(response.body)
    end
  end
end
