require 'logger'

module Spackle
  module Waiters
    def self.wait_for_customer(customer_id, timeout = 15)
      start = Time.now.to_i
      while Time.now.to_i - start < timeout do
        begin
          return Spackle::Customer.retrieve(customer_id)
        rescue SpackleError
          sleep 1
        end
      end

      raise SpackleError.new "Timeout waiting for customer #{customer_id}"
    end

    def self.wait_for_subscription(customer_id, subscription_id, timeout=15, **filters)
      start = Time.now.to_i
      while Time.now.to_i - start < timeout do
        begin
          customer = Spackle::Customer.retrieve(customer_id)
          customer.subscriptions.each do |s|
            if s.id == subscription_id and filters.all? { |k, v| s.send(k) == v }
              return s
            end
          end
          sleep 1
        rescue SpackleError
          sleep 1
        end
      end

      raise SpackleError.new "Timeout waiting for subscription #{subscription_id}"
    end
  end
end
