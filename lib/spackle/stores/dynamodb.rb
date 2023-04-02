require 'aws-sdk'
require 'net/http'
require 'json'
require 'logger'

module Spackle
  class DynamoDBStore < BaseStore
    @client = nil
    @store_config = {}

    def initialize(client = nil, store_config = nil)
      @store_config = store_config || {}
      @client = client || bootstrap_client
    end

    def get_customer_data(id)
      result = get_item(id)

      if result.nil? or result.item.nil?
        raise SpackleError.new "Customer #{id} not found"
      end

      JSON.parse(result.item['State'])
    end

    private

    def get_item(id)
      return @client.get_item({
        table_name: @store_config['table_name'],
        key: {
          AccountId: @store_config['identity_id'],
          CustomerId: "#{id}:#{Spackle.version}"
        }
      })
    rescue StandardError
        return nil
    end

    def bootstrap_client
      Util.log_debug('Bootstrapping DynamoDB client...')

      if Spackle.api_key.nil?
        raise SpackleError.new 'API key not set'
      end

      uri = URI(Spackle.api_base + '/sessions')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Authorization'] = 'Bearer ' + Spackle.api_key

      response = https.request(request)
      data = JSON.parse(response.body)
      Util.log_debug("Created session: #{data}")

      @store_config = data['adapter']
      credentials = SpackleCredentials.new(
        @store_config['role_arn'],
        @store_config['token'],
        @store_config['region'],
      )

      Aws::DynamoDB::Client.new(
        credentials: credentials,
      )
    end
  end

  class SpackleCredentials
    include Aws::CredentialProvider
    include Aws::RefreshingCredentials

    @region = nil
    @role_arn = nil
    @token = nil

    def initialize(role_arn, token, region)
      @region = region
      @role_arn = role_arn
      @token = token
      @client = Aws::STS::Client.new(
        region: @region,
        credentials: false,
      )
      super()
    end

    private

    def refresh
      Util.log_debug('Refreshing DynamoDB credentials...')
      c = @client.assume_role_with_web_identity({
        role_arn: @role_arn,
        role_session_name: Base64.strict_encode64(SecureRandom.uuid),
        web_identity_token: @token
      }).credentials
      @credentials = Aws::Credentials.new(
        c.access_key_id,
        c.secret_access_key,
        c.session_token
      )
      @expiration = c.expiration
    end
  end
end
