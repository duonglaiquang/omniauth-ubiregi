require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Ubiregi < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://ubiregi.com',
        authorize_url: 'https://ubiregi.com/oauth2/authorize',
        token_url: 'https://ubiregi.com/oauth2/token',
        auth_scheme: :basic_auth,
      }

      option :authorize_params, {
        force_login: true,
        force_authorize: true
      }

      uid { raw_info["id"] }

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        Rails.logger.error "run to here"
        @raw_info ||= access_token.get('/api/3/accounts/current').parsed
        Rails.logger.error "raw: #{@raw_info}"
        @raw_info.parsed["account"] || {}
      end

      def callback_url
        full_host + script_name + callback_path
      end

      protected

      def build_access_token
        verifier = request.params["code"]
        client.get_token(
          {
            grant_type: "authorization_code",
            code: verifier,
            redirect_uri: callback_url,
          }.merge(token_params.to_hash(symbolize_keys: true)),
          deep_symbolize(options.auth_token_params)
        )
      end
    end
  end
end
