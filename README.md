# Omniauth::FranceConnect

Omniauth FranceConnect is a strategy based on [omniauth_openid_connect gem](https://github.com/omniauth/omniauth_openid_connect). It allows to implement France Connect SSO strategy in your Rails application.  

## Installation

Add this line to your application's Gemfile:

```
gem 'omniauth-openid-connect', git: "https://github.com/OpenSourcePolitics/omniauth-france_connect"
```

And then execute:

```
bundle install
```
Or install it yourself as:

```
gem install omniauth-openid-connect
```

## Usage

You must create a new initializer under `config/initializers/` named as you want like `omniauth_france_connect.rb`.

Then add into this file : 
```
# frozen_string_literal: true

if Rails.application.secrets.dig(:omniauth, :france_connect).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :france_connect,
      setup: lambda { |env|
        request = Rack::Request.new(env)
        organization = Decidim::Organization.find_by(host: request.host)
        provider_config = organization.enabled_omniauth_providers[:france_connect]
        env["omniauth.strategy"].options[:client_id] = provider_config[:client_id]
        env["omniauth.strategy"].options[:client_secret] = provider_config[:client_secret]
        env["omniauth.strategy"].options[:site] = provider_config[:site_url]
      },
      scope: [:openid, :birthdate]
    )
  end
end

if Rails.application.secrets.dig(:omniauth, :france_connect_profile).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :france_connect_profile,
      setup: setup_provider_proc(:france_connect_profile,
                                 site: :site,
                                 client_id: :client_id,
                                 client_secret: :client_secret,
                                 end_session_endpoint: :end_session_endpoint,
                                 icon_path: :icon_path,
                                 button_path: :button_path,
                                 provider_name: :provider_name,
                                 minimum_age: :minimum_age)
    )
  end
end

if Rails.application.secrets.dig(:omniauth, :france_connect_uid).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :france_connect_uid,
      setup: setup_provider_proc(:france_connect_uid,
                                 site: :site,
                                 client_id: :client_id,
                                 client_secret: :client_secret,
                                 end_session_endpoint: :end_session_endpoint,
                                 icon_path: :icon_path,
                                 button_path: :button_path,
                                 provider_name: :provider_name,
                                 minimum_age: :minimum_age)
    )
  end
end
```

__NOTE__: Please note that this initializer is made for working with [Decidim](https://github.com/decidim/decidim), you will probably need to update to match your project.

Then add new keys in your `config/secrets.yml` file like below : 
```
# config/secrets.yml
en:
    default:
        omniauth:
            france_connect:
              enabled: <%= ENV["OMNIAUTH_FC_CLIENT_SECRET"].present? %>
              client_id: <%= ENV["OMNIAUTH_FC_CLIENT_ID"] %>
              client_secret: <%= ENV["OMNIAUTH_FC_CLIENT_SECRET"] %>
              site_url: <%= ENV["OMNIAUTH_FC_SITE_URL"] %>
            france_connect_profile:
              enabled: <%= ENV["OMNIAUTH_FRANCE_CONNECT_PROFILE_CLIENT_SECRET"].present? %>
              provider_name: "France Connect Auteur"
              client_id: <%= ENV["OMNIAUTH_FRANCE_CONNECT_PROFILE_CLIENT_ID"] %>
              client_secret: <%= ENV["OMNIAUTH_FRANCE_CONNECT_PROFILE_CLIENT_SECRET"] %>
              site: <%= ENV["OMNIAUTH_FRANCE_CONNECT_PROFILE_SITE_URL"] %>
            france_connect_uid:
              enabled: <%= ENV["OMNIAUTH_FRANCE_CONNECT_UID_CLIENT_SECRET"].present? %>
              provider_name: "France Connect Signataire"
              site: <%= ENV["OMNIAUTH_FRANCE_CONNECT_UID_SITE"] %>
              client_id: <%= ENV["OMNIAUTH_FRANCE_CONNECT_UID_CLIENT_ID"] %>
              client_secret: <%= ENV["OMNIAUTH_FRANCE_CONNECT_UID_CLIENT_SECRET"] %>
```

As you may have noticed, there is 3 kinds of strategy for France Connect : 

1. `FranceConnect` that allows to log with several informations returned by France Connect
2. `FranceConnectProfile` that allows to log in with less informations returned by France Connect
3. `FranceConnectUid` that allows to log in as anonymous. Only UID is stored as nickname.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/OpenSourcePolitics/omniauth-france_connect. This project is intended to be a safe, welcoming space for collaboration.

Please, for security issue, do not open issue on Github but send an email to :

* security [at] opensourcepolitics.eu

Thanks !

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Open Source Politics.
