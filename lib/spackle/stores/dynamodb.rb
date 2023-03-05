require 'aws-sdk'
require 'net/http'
require 'json'
require 'logger'

module Spackle
  class DynamoDBStore
    @client = nil
    @store_config = {}

    def initialize(client = nil, store_config = nil)
      @client = client || bootstrap_client
      @store_config = store_config || {}
    end

    def get_customer_data(id)
      data = query({
        key_condition_expression: 'CustomerId = :customer_id',
        filter_expression: 'Version = :version',
        expression_attribute_values: {
          ':customer_id' => id,
          ':version' => Spackle.version
        },
        limit: 1
      })

      if not data.items.any?
        raise SpackleError.new "Customer #{id} not found"
      end

      data
    end

    private

    def get_item(key)
      key = key.merge({
        'AccountId' => @store_config['identity_id'],
      })

      response = @client.get_item({
        table_name: @table_name,
        key: key
      })

      JSON.parse(response.item['State'])
    end

    def query(query)
      query[:table_name] = @store_config['table_name']
      query[:key_condition_expression] = 'AccountId = :account_id AND ' + query[:key_condition_expression]
      query[:expression_attribute_values] = query[:expression_attribute_values].merge({
        ':account_id' => @store_config['identity_id']
      })
      @client.query(query)
    end

    def bootstrap_client
      Util.log_debug('Bootstrapping DynamoDB client...')
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
        @store_config['token']
      )

      Aws::DynamoDB::Client.new(
        credentials: credentials,
      )
    end
  end

  class SpackleCredentials
    include Aws::CredentialProvider
    include Aws::RefreshingCredentials

    @role_arn = nil
    @token = nil

    def initialize(role_arn, token)
      @client = Aws::STS::Client.new(:credentials => false)
      @role_arn = role_arn
      @token = token
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
