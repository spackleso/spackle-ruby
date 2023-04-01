require 'spackle'
require 'minitest/autorun'

class DynamoDBStoreTest < Minitest::Test
  def test_retrieve()
    mock = Minitest::Mock.new
    def mock.get_item(table_item)
      res = Minitest::Mock.new
      res.expect :nil?, false
      res.expect :item, {"CustomerId" => "cus_000000000", "State" => "{\"subscriptions\":[],\"features\":[{\"type\":0,\"key\":\"flag\",\"value_flag\":true}]}"}
      res.expect :item, {"CustomerId" => "cus_000000000", "State" => "{\"subscriptions\":[],\"features\":[{\"type\":0,\"key\":\"flag\",\"value_flag\":true}]}"}
    end

    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::DynamoDBStore.new(mock, {'table_name' => 'test', 'identity_id' => 'test'})
    customer = Spackle::Customer.retrieve('cus_000000000')
    assert customer.enabled('flag')
  end
end
