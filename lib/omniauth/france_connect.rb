# frozen_string_literal: true

require "omniauth/openid_connect"
require "omniauth/france_connect/version"
require "omniauth/strategies/france_connect"
require "omniauth/strategies/france_connect_uid"

module OmniAuth
  # Implement France Connect Omniauth strategy in your application
  module FranceConnect
    include ActiveSupport::Configurable

    class Error < StandardError; end
  end
end
