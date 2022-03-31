# frozen_string_literal: true

require "omniauth-oauth2"
require "open-uri"

module OmniAuth
  module Strategies
    class FranceConnect < OmniAuth::Strategies::OpenIDConnect
    end
  end
end
