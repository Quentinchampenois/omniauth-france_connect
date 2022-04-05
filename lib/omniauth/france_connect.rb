# frozen_string_literal: true

require "byebug"
require "omniauth/openid_connect"
require "omniauth/france_connect/version"

module Omniauth
  # Implement France Connect Omniauth strategy in your application
  module FranceConnect
    include ActiveSupport::Configurable

    class Error < StandardError; end

    # Define scope for FranceConnect
    config_accessor :scope do
      %i[openid email preferred_username]
    end

    module Strategy
      class FranceConnect < OmniAuth::Strategies::OpenIDConnect
        option :name, :france_connect
        option :origin_param, "redirect_uri"

        option :site
        option :client_id
        option :client_secret
        option :end_session_endpoint

        option :scope, Omniauth::FranceConnect.scope
      end
    end
  end
end
