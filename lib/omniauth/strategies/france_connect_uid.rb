require "omniauth/strategies/france_connect"

module OmniAuth
  module Strategies
    class FranceConnectUid < OmniAuth::Strategies::FranceConnect

      option :name, :france_connect_uid
      option :scope, [:openid, :birthdate]

      info do
        {
          name: "Anonyme",
          nickname: uid,
          email: ""
        }
      end
    end
  end
end
