require 'spackle'
require 'minitest/autorun'

class PricingTableTest < Minitest::Test
  def test_retrieve
    data = {
      'id' => 'abcde123',
      'name' => 'Test Pricing Table',
      'intervals' => ['month', 'year'],
      'products' => [
        {
          'id' => 'prod_000000000',
          'features' => [
            {
              'key' => 'flag',
              'type' => 0,
              'name' => 'Flag',
              'value_flag' => true
            }
          ],
          'name' => 'Basic',
          'prices' => {
            'month' => {
              'unit_amount' => 1000,
              'currency' => 'usd',
            },
            'year' => {
              'unit_amount' => 10000,
              'currency' => 'usd',
            }
          }
        }
      ]
    }

    stub_request(:get, "https://api.spackle.so/v1/pricing_tables/abcde123")
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer abc123',
          'Connection'=>'keep-alive',
          'Keep-Alive'=>'30',
          'User-Agent'=>'Faraday v2.7.10',
        }
      )
      .to_return(
        status: 200,
        body: data.to_json,
        headers: {}
      )

    Spackle.api_key = 'abc123'
    Spackle.store = Spackle::EdgeStore.new()
    pricing_table = Spackle::PricingTable.retrieve('abcde123')
    assert pricing_table == data
  end
end
