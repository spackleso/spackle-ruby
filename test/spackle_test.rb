require 'spackle'
require 'minitest/autorun'

class SpackleTest < Minitest::Test
  def test_api_key_configuration
    Spackle.api_key = 'abc123'
    assert_equal Spackle.api_key, 'abc123'
  end
end
