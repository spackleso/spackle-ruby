require 'spackle'
require 'minitest/autorun'

class DynamoDBStoreTest < Minitest::Test
  def test_retrieve()
    Spackle.api_key = 'abc123'

    credentials = Minitest::Mock.new
    credentials.expect :session, {"adapter"=>{"region"=>"us-east-1", "table_name" => "spackle", "identity_id" => "acc_123"}}
    credentials.expect :session, {"adapter"=>{"region"=>"us-east-1", "table_name" => "spackle", "identity_id" => "acc_123"}}
    credentials.expect :session, {"adapter"=>{"region"=>"us-east-1", "table_name" => "spackle", "identity_id" => "acc_123"}}

    item = Minitest::Mock.new
    item.expect :nil?, false
    item.expect :item, {"CustomerId" => "cus_000000000", "State" => "{\"subscriptions\":[],\"features\":[{\"type\":0,\"key\":\"flag\",\"value_flag\":true}]}"}
    item.expect :item, {"CustomerId" => "cus_000000000", "State" => "{\"subscriptions\":[],\"features\":[{\"type\":0,\"key\":\"flag\",\"value_flag\":true}]}"}

    client = Minitest::Mock.new
    client.expect :get_item, item, [{table_name: "spackle", key: {AccountId: "acc_123", CustomerId: "cus_000000000:#{Spackle.version}"}}]

    Spackle::SpackleAWSCredentials.stub :new, credentials do
      Aws::DynamoDB::Client.stub :new, client do
        Spackle.store = Spackle::DynamoDBStore.new()
        customer = Spackle::Customer.retrieve('cus_000000000')
        assert customer.enabled('flag')
      end
    end
  end
end
