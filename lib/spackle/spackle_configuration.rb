module Spackle
  class SpackleConfiguration
    attr_accessor :api_key
    attr_accessor :api_base

    def initialize
      @api_base = 'https://api.spackle.so'
    end
  end
end
