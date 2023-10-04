require 'spackle'
require 'minitest/autorun'
require 'webmock/minitest'


class EdgeStoreTest < Minitest::Test
  def test_retrieve()
    stub_request(:get, "https://us-west-2.edge.spackle.so/customers/cus_000000000/state")
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer abc123',
          'Connection'=>'keep-alive',
          'Keep-Alive'=>'30',
          'User-Agent'=>'Faraday v2.7.10',
          'X-Spackle-Schema-Version'=>'1'
        }
      )
      .to_return(
        status: 200,
        body: "{\"subscriptions\":[],\"features\":[{\"type\":0,\"key\":\"flag\",\"value_flag\":true}]}",
        headers: {}
      )
    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::EdgeStore.new()
    customer = Spackle::Customer.retrieve('cus_000000000')
    assert customer.enabled('flag')
  end

  def test_api_fallback()
    stub_request(:get, "https://us-west-2.edge.spackle.so/customers/cus_000000000/state")
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer abc123',
          'Connection'=>'keep-alive',
          'Keep-Alive'=>'30',
          'User-Agent'=>'Faraday v2.7.10',
          'X-Spackle-Schema-Version'=>'1'
        }
      )
      .to_return(
        status: 404,
        body: "",
        headers: {}
      )

    stub_request(:get, "https://api.spackle.so/v1/customers/cus_000000000/state")
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer abc123',
          'User-Agent'=>'Faraday v2.7.10',
          'X-Spackle-Schema-Version'=>'1'
        }
      )
      .to_return(
        status: 200,
        body: "{\"subscriptions\":[],\"features\":[{\"type\":0,\"key\":\"flag\",\"value_flag\":true}]}",
        headers: {}
      )

    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::EdgeStore.new()
    customer = Spackle::Customer.retrieve('cus_000000000')
    assert customer.enabled('flag')
  end
end
