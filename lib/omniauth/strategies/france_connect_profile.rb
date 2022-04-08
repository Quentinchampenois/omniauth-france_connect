# frozen_string_literal: true

require "omniauth/strategies/france_connect"

module OmniAuth
  module Strategies
    # FranceConnectProfile allows to connect to France Connect and having multiple personal information
    class FranceConnectProfile < OmniAuth::Strategies::FranceConnect
      option :name, :france_connect_profile
      option :scope, [:email, :openid, :birthdate, :given_name, :family_name, :preferred_username]

      info do
        {
          name: user_info.given_name&.strip,
          email: user_info.email,
          nickname: user_info.preferred_username,
          first_name: user_info.given_name&.strip,
          last_name: user_info.family_name&.strip
        }
      end
    end
  end
end
