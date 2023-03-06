module Spackle
  class MemoryStore < BaseStore
    @data = {}

    def initialize()
      @data = {}
    end

    def get_customer_data(id)
      if !@data.has_key?(id)
        raise SpackleError.new "Customer #{id} not found"
      end

      @data[id]
    end

    def set_customer_data(id, customer_data)
      @data[id] = customer_data
    end
  end
end
