module Spackle
  class BaseStore
    def get_customer_data(id)
      raise NoMethodError, 'get_customer_data not implemented'
    end

    def set_customer_data(id, data)
      raise NoMethodError, 'set_customer_data not implemented'
    end
  end
end
