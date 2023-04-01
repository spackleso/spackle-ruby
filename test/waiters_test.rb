require 'minitest/autorun'
require 'spackle'

class WaitersTest < Minitest::Test
  def test_wait_for_customer
    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::MemoryStore.new()

    assert_raises Spackle::SpackleError  do
      Spackle::Waiters.wait_for_customer('cus_000000000', 1)
    end

    Spackle.store.set_customer_data('cus_000000000', {
      "subscriptions" => [],
      "features" => [
        {
          "type" => 0,
          "key" => "flag",
          "value_flag" => true
        }
      ]
    })
    customer = Spackle::Waiters.wait_for_customer('cus_000000000')
    assert customer.id == 'cus_000000000'
  end

  def test_wait_for_subscription
    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::MemoryStore.new()
    Spackle.store.set_customer_data('cus_000000000', {
      "subscriptions" => [],
      "features" => [
        {
          "type" => 0,
          "key" => "flag",
          "value_flag" => true
        }
      ]
    })

    assert_raises Spackle::SpackleError  do
      Spackle::Waiters.wait_for_subscription('cus_000000000', 'sub_000000000', 1)
    end

    Spackle.store.set_customer_data('cus_000000000', {
      "subscriptions" => [{
        "id" => "sub_000000000",
      }],
      "features" => [
        {
          "type" => 0,
          "key" => "flag",
          "value_flag" => true
        }
      ]
    })
    subscription = Spackle::Waiters.wait_for_subscription('cus_000000000', 'sub_000000000', 1)
    assert subscription.id == 'sub_000000000'
  end

  def test_wait_for_subscription_with_status_filter
    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::MemoryStore.new()
    Spackle.store.set_customer_data('cus_000000000', {
      "subscriptions" => [{
        "id" => "sub_000000000",
        "status" => "trialing"
      }],
      "features" => [
        {
          "type" => 0,
          "key" => "flag",
          "value_flag" => true
        }
      ]
    })

    assert_raises Spackle::SpackleError  do
      Spackle::Waiters.wait_for_subscription('cus_000000000', 'sub_000000000', 1, status: 'active')
    end

    Spackle.store.set_customer_data('cus_000000000', {
      "subscriptions" => [{
        "id" => "sub_000000000",
        "status" => "active"
      }],
      "features" => [
        {
          "type" => 0,
          "key" => "flag",
          "value_flag" => true
        }
      ]
    })
    subscription = Spackle::Waiters.wait_for_subscription('cus_000000000', 'sub_000000000', 1, status: 'active')
    assert subscription.id == 'sub_000000000'
  end
end
