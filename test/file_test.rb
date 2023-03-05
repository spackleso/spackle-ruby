require 'minitest/autorun'
require 'spackle'

class FileStoreTest < Minitest::Test
  def test_retrieve()
    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::FileStore.new('/tmp/spackle.json')
    Spackle.store.set_customer_data('cus_000000000', {
      'subscriptions' => [],
      'features' => [
        {
          'type' => 0,
          'key' => 'flag',
          'value_flag' => true
        }
      ]
    })

    customer = Spackle::Customer.retrieve('cus_000000000')
    assert customer.enabled('flag')
  end
end
