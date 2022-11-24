# frozen_string_literal: true

module OmniAuth
  module Strategies
    # FranceConnect Omniauth strategy
    class FranceConnect < OpenIDConnect
      option :name, :france_connect
      option :origin_param, "redirect_uri"

      option :site
      option :client_id
      option :client_secret
      option :end_session_endpoint

      option :scope # Array of string or symbol

      option :client_signing_alg, :HS256
      option :client_auth_method, :body
      option :acr_values, "eidas1"

      info do
        {
          name: fullname,
          email: raw_info.email,
          nickname: find_nickname,
          first_name: raw_info.given_name,
          last_name: find_name,
          preferred_username: raw_info.preferred_username,
          birthdate: raw_info.birthdate,
          idp_birthdate: raw_info.idp_birthdate,
          birthplace: raw_info.birthplace,
          birthcountry: raw_info.birthcountry,
          gender: raw_info.gender
        }.compact.transform_values(&:strip)
      end

      def fullname
        "#{raw_info.given_name&.split(" ")&.first} #{find_name}"
      end

      def find_nickname
        find_name.presence || uid
      end

      def find_name
        raw_info.preferred_username.presence || raw_info.family_name
      end

      def raw_info
        @raw_info ||= OpenStruct.new(user_info.raw_attributes)
      end

      def auth_hash
        hash = super
        hash.logout = end_session_uri
        hash
      end

      def end_session_uri
        return unless client_options.end_session_endpoint.present?

        end_session_uri = URI(options.issuer + client_options.end_session_endpoint)
        session["omniauth_logout"] = end_session_uri
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
          jwks_uri: "/api/v1/jwk",
          end_session_endpoint: "/api/v1/logout"
        }

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
