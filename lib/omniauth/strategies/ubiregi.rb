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
        @raw_info ||= access_token.get('/api/3/accounts/current').parsed["account"] || {}
      end

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
