module Spackle
  class Customer
    @data = nil

    def self.retrieve(id)
      Util.log_debug("Retrieving customer data for #{id}")
      data = Spackle.client.query({
        key_condition_expression: 'CustomerId = :customer_id',
        filter_expression: 'Version = :version',
        expression_attribute_values: {
          ':customer_id' => id,
          ':version' => Spackle.version
        },
        limit: 1
      })
      Util.log_debug("Retrieved customer data for #{id}: #{data}")
      Customer.new(data)
    end

    def initialize(data)
      @data = data
    end

    def enabled(key)
      @data['features'].each do |f|
        if f['key'] == key
          return f['value_flag']
        end
      end

      return false
    end

    def limit(key)
      @data['features'].each do |f|
        if f['key'] == key
          return f['value_limit']
        end
      end

      return 0
    end
  end
end
