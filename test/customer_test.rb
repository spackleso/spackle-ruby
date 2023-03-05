require 'spackle'
require 'minitest/autorun'

class CustomerTest < Minitest::Test
  def test_enabled
    customer = Spackle::Customer.new({
      'subscriptions' => [],
      'features' => [{
        'type' => 0,
        'key' => 'flag',
        'value_flag' => true
      }]
    })

    assert customer.enabled('flag')
    assert_raises Spackle::SpackleError do
      customer.enabled('not_found')
    end
  end

  def test_limit
    customer = Spackle::Customer.new({
      'subscriptions' => [],
      'features' => [
        {
          'type' => 1,
          'key' => 'limit',
          'value_limit' => 100
        },
        {
          'type' => 1,
          'key' => 'unlimited',
          'value_limit' => nil
        }
      ]
    })

    assert_equal customer.limit('limit'), 100
    assert customer.limit('unlimited') > 100
    assert_equal customer.limit('unlimited'), Float::INFINITY

    assert_raises Spackle::SpackleError do
      customer.limit('not_found')
    end
  end
end
