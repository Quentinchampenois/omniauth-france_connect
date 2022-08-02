# frozen_string_literal: true

require "omniauth/france_connect"

class DummyApp
  def call(env); end
end

module OmniAuth
  module Strategies
    RSpec.describe FranceConnect do
      let(:subject) do
        described_class.new(DummyApp.new).tap do |strategy|
          strategy.options.client_options.identifier = "dummy"
          strategy.options.client_options.secret = "dummy_secret"
          strategy.options.client_options.redirect_uri = site
          strategy.options.scope = %i[openid email preferred_username]
          strategy.options.site = site
        end
      end
      let(:site) { "https://example.com" }

      it "returns correct strategy name" do
        expect(subject.options.name).to eq(:france_connect)
      end

      it "returns option site" do
        expect(subject.options.site).to eq(site)
      end

      it "returns default undefined client_id" do
        expect(subject.options.client_id).to be_nil
      end

      it "returns default undefined client_secret" do
        expect(subject.options.client_secret).to be_nil
      end

      it "returns default undefined end_session_endpoint" do
        expect(subject.options.end_session_endpoint).to be_nil
      end

      it "returns list of scope" do
        expect(subject.options.scope).to eq(%i[openid email preferred_username])
      end

      describe "#issuer" do
        let(:subject) do
          described_class.new(DummyApp.new).tap do |strategy|
            strategy.options.client_options.identifier = "dummy"
            strategy.options.client_options.secret = "dummy_secret"
            strategy.options.scope = %i[openid email preferred_username]
            strategy.options.site = site
          end
        end

        it "returns the site option" do
          expect(subject.send(:issuer)).to eq(site)
        end
      end
    end
  end
end
