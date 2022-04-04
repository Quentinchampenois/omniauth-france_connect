# frozen_string_literal: true

require "omniauth/openid_connect"
require "omniauth/france_connect/version"

module Omniauth
  module FranceConnect
    class Error < StandardError; end

    module Strategy
      class FranceConnect < OmniAuth::Strategies::OpenIDConnect
        option :name, :france_connect
        option :origin_param, "redirect_uri"

        option :site
        option :client_id
        option :client_secret
        option :end_session_endpoint
      end
    end
  end
end
