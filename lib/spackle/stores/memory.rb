module Spackle
  class MemoryStore < BaseStore
    @data = {}

    def initialize()
      @data = {}
    end

    def get_customer_data(id)
      @data[id]
    end

    def set_customer_data(id, customer_data)
      @data[id] = customer_data
    end
  end
end
