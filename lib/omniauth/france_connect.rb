# frozen_string_literal: true

require "omniauth/openid_connect"
require "omniauth/france_connect/version"

module Omniauth
  module FranceConnect
    class Error < StandardError; end

    # Override strategy configuration using Core class
    class Core
      include ActiveSupport::Configurable

      # Define scope for FranceConnect
      config_accessor :scope do
        %i[openid email preferred_username]
      end
    end

    module Strategy
      class FranceConnect < OmniAuth::Strategies::OpenIDConnect
        option :name, :france_connect
        option :origin_param, "redirect_uri"

        option :site
        option :client_id
        option :client_secret
        option :end_session_endpoint

        option :scope, Omniauth::FranceConnect::Core.scope
      end
    end
  end
end
