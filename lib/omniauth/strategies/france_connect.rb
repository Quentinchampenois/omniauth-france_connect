# frozen_string_literal: true

module Omniauth
  module Strategies
    # FranceConnect Omniauth strategy
    class FranceConnect < OmniAuth::Strategies::OpenIDConnect
      option :name, :france_connect
      option :origin_param, "redirect_uri"

      option :site
      option :client_id
      option :client_secret
      option :end_session_endpoint

      option :scope, %i[openid email preferred_username]
      option :client_signing_alg, :HS256
      option :client_auth_method, :body
      option :acr_values, "eidas1"

      def authorize_uri
        super + (options.acr_values.present? ? "&acr_values=#{options.acr_values}" : "")
      end

      def auth_hash
        hash = super
        hash.logout = end_session_uri
        hash
      end

      def end_session_uri
        return unless client_options.end_session_endpoint.present?

        end_session_uri = URI(options.issuer + client_options.end_session_endpoint)
        end_session_uri.query = URI.encode_www_form(
          id_token_hint: credentials[:id_token],
          state: session_state,
          post_logout_redirect_uri: "#{full_host}/users/auth/#{options.name}/logout"
        )
        end_session_uri.to_s
      end

      private

      def issuer
        options.site
      end

      # rubocop:disable Metrics/MethodLength
      def client_options
        site_url = URI(options.site)

        client_options_hash = {
          host: site_url.host,
          port: site_url.port,
          identifier: options.client_id,
          secret: options.client_secret,
          authorization_endpoint: "/api/v1/authorize",
          token_endpoint: "/api/v1/token",
          userinfo_endpoint: "/api/v1/userinfo",
          jwks_uri: "/api/v1/jwk"
        }

        if options.end_session_endpoint.present?
          client_options_hash[:end_session_endpoint] =
            options.end_session_endpoint
        end

        options.client_options.merge client_options_hash
      end
      # rubocop:enable Metrics/MethodLength

      def redirect_uri
        return omniauth_callback_url unless params["redirect_uri"]

        "#{omniauth_callback_url}?redirect_uri=#{CGI.escape(params["redirect_uri"])}"
      end

      def omniauth_callback_url
        full_host + script_name + callback_path
      end

      def new_state
        session["omniauth.state"] = SecureRandom.hex(16)
      end

      def session_state
        session["omniauth.state"] = params["state"] || SecureRandom.hex(16)
      end

      def other_phase
        call_app!
      end
    end
  end
end
