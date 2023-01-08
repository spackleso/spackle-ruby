require 'aws-sdk'
require 'net/http'
require 'json'

module Spackle
  class DynamoDB
    @client = nil
    @identity_id = nil
    @table_name = nil
    @aws_region = nil

    def initialize
      @client = bootstrap_client
    end

    def get_item(key)
      key = key.merge({
        'AccountId' => @identity_id,
      })

      response = @client.get_item({
        table_name: @table_name,
        key: key
      })

      JSON.parse(response.item['State'])
    end

    private


    def bootstrap_client
      uri = URI(Spackle.api_base + '/auth/session')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Authorization'] = 'Bearer ' + Spackle.api_key

      response = https.request(request)
      data = JSON.parse(response.body)

      @identity_id = data['identity_id']
      @table_name = data['table_name']
      @aws_region = data['aws_region']

      credentials = SpackleCredentials.new(
        data['role_arn'],
        data['token']
      )

      Aws::DynamoDB::Client.new(
        region: @aws_region,
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
