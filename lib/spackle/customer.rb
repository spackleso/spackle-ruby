module Spackle
  class Customer
    @data = nil

    def self.retrieve(id)
      Util.log_debug("Retrieving customer data for #{id}")
      data = Spackle.store.get_customer_data(id)
      Util.log_debug("Retrieved customer data for #{id}: #{data}")
      Customer.new(JSON.parse(data.items[0]['State']))
    end

    def initialize(data)
      @data = data
    end

    def features
      return @data['features']
    end

    def flag_features
      features.select { |f| f['type'] == 0 }
    end

    def limit_features
      features.select { |f| f['type'] == 1 }
    end

    def enabled(key)
      flag_features.each do |f|
        if f['key'] == key
          return f['value_flag']
        end
      end

      raise SpackleError.new "Flag feature #{key} not found"
    end

    def limit(key)
      @data['features'].each do |f|
        if f['key'] == key
          return f['value_limit'] || Float::INFINITY
        end
      end

      raise SpackleError.new "Limit feature #{key} not found"
    end
  end
end
