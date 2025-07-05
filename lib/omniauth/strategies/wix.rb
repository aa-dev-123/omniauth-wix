require 'omniauth/strategies/oauth2'
require 'rest-client'

module OmniAuth
  module Strategies
    class Wix < OmniAuth::Strategies::OAuth2
      option :provider_ignores_state, true # If true, skips CSRF check

      option :client_options, {
        site: 'https://www.wix.com', # The base URL of the site where authorize_url and token_url will append
        authorize_url: '/installer/install', 
        token_url: '/oauth/access'
      }

      uid { raw_info['instance']['instanceId'] }

      info do
        {
          site_url: raw_info['site']['url'],
          email: raw_info['site']['ownerEmail']
        }
      end

      extra do
        {
          'raw_info' => raw_info['site']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://www.wixapis.com/apps/v1/instance').parsed
      end

      # This method starts the OAuth flow by redirecting the user to the provider's authorization URL.
      def request_phase
        request_params = authorize_params
        get_params = session['omniauth.params'] || {}
        request_params['token'] = get_params['token'] if get_params['token']
        request_params['appId'] = options.client_id

        redirect client.auth_code.authorize_url({ redirectUrl: callback_url }.merge(request_params))
      end

      def callback_url
        full_host + script_name + callback_path
      end

      # overides the build_access_token method
      # that is used in callback_phase
      def build_access_token
        params = {
          'grant_type': 'authorization_code',
          'client_id': client.id,
          'client_secret': client.secret,
          'code': request.params['code']
        }
        resp = RestClient::Request.execute(method: client.options[:token_method],
                                           url: client.token_url,
                                           payload: params.to_json,
                                           headers: { content_type: :json })

        ::OAuth2::AccessToken.from_hash(
          client,
          JSON.parse(resp).symbolize_keys.merge({ expires_in: 10.minutes })
        )
      end
    end
  end
end
