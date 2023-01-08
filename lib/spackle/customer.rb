module Spackle
  class Customer
    @data = nil

    def self.retrieve(id)
      data = Spackle.client.get_item({
        'CustomerId' => id
      })
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