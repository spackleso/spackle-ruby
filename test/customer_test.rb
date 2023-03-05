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

  def test_subscriptions
    customer = Spackle::Customer.new({
      "subscriptions" => [
          {
              "id" => "sub_123",
              "status" => "active",
              "items" => {
                  "data" => [
                      {
                          "id" => "si_123",
                          "price" => {
                              "id" => "price_123",
                              "product" => {
                                  "id" => "prod_123",
                              },
                          },
                      }
                  ]
              },
          }
      ],
      "features" => [{"key" => "foo", "value_flag" => true, "type" => 0}],
    })
    assert customer.subscriptions.size == 1
    assert customer.subscriptions[0].id == "sub_123"
    assert customer.subscriptions[0].status == "active"
  end
end
