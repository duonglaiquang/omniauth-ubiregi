require 'base64'
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Ubiregi < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://ubiregi.com',
        authorize_url: 'https://ubiregi.com/oauth2/authorize',
        token_url: 'https://ubiregi.com/oauth2/token'
      }

      uid { raw_info["id"] }

      info do
        {
          email: raw_info['email'],
          name: raw_info['name']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/3/accounts/current').parsed["account"] || {}
      end

      protected

      def build_access_token
        verifier = request.params["code"]
        basic_authorization = authorization(options['client_id'], options['client_secret'])
        client.auth_code.get_token(verifier, { redirect_uri: callback_url, headers: { 'Authorization' => basic_authorization }}.merge(token_params.to_hash(symbolize_keys: true)), deep_symbolize(options.auth_token_params))
      end

      def authorization(client_id, client_secret)
        'Basic ' + Base64.encode64(client_id + ':' + client_secret).gsub("\n", '')
      end
    end
  end
end
