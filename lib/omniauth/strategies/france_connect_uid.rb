# frozen_string_literal: true

require "omniauth/strategies/france_connect"

module OmniAuth
  module Strategies
    # FranceConnectUid allows to connect to France Connect without personal information and only UID
    class FranceConnectUid < OmniAuth::Strategies::FranceConnect
      option :name, :france_connect_uid
      option :scope, [:openid]

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
