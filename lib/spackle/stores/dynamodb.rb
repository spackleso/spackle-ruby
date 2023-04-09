require 'aws-sdk'
require 'net/http'
require 'json'
require 'logger'

module Spackle
  class DynamoDBStore < BaseStore
    @client = nil
    @credentials = nil

    def initialize()
      @client = bootstrap_client
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
        table_name: @credentials.session['adapter']['table_name'],
        key: {
          AccountId: @credentials.session['adapter']['identity_id'],
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

      @credentials = SpackleAWSCredentials.new
      Aws::DynamoDB::Client.new(
        region: @credentials.session['adapter']['region'],
        credentials: @credentials,
      )
    end
  end

  class SpackleAWSCredentials
    include Aws::CredentialProvider
    include Aws::RefreshingCredentials

    @client = nil
    @session = {}

    def initialize()
      @session = create_session
      @client = Aws::STS::Client.new(
        region: @session['adapter']['region'],
        credentials: false,
      )
      super()
    end

    def session
      @session
    end

    private

    def create_session
      uri = URI(Spackle.api_base + '/sessions')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Authorization'] = 'Bearer ' + Spackle.api_key

      response = https.request(request)
      data = JSON.parse(response.body)
      Util.log_debug("Created session: #{data}")
      data
    end

    def refresh
      Util.log_debug('Refreshing DynamoDB credentials...')
      c = @client.assume_role_with_web_identity({
        role_arn: @session['adapter']['role_arn'],
        role_session_name: Base64.strict_encode64(SecureRandom.uuid),
        web_identity_token: @session['adapter']['token'],
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
