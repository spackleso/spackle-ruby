require 'spackle'
require 'test/unit'

class CustomerTest < Test::Unit::TestCase
  def test_enabled
    customer = Spackle::Customer.new({
      'subscriptions' => [],
      'features' => [{
        'key' => 'flag',
        'value_flag' => true
      }]
    })
    assert customer.enabled('flag')
  end

  def test_limit
    customer = Spackle::Customer.new({
      'subscriptions' => [],
      'features' => [{
        'key' => 'flag',
        'value_limit' => 100
      }]
    })
    assert_equal customer.limit('flag'), 100
  end
end
