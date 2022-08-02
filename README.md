# Omniauth::FranceConnect

Omniauth FranceConnect is a strategy based on [omniauth_openid_connect gem](https://github.com/omniauth/omniauth_openid_connect). It allows to implement France Connect SSO strategy in your Rails application.  

__Please note you will need France Connect credentials to make it work.__  
These credentials will include the scope of user information you are authorize to retrieve from this provider.  
Using a scope with more information than what was originally authorized will throw a __blocking__ error on user authentification.  

Find more information about France Connect at https://partenaires.franceconnect.gouv.fr/fcp/fournisseur-service (French).

## Installation

Add this line to your application's Gemfile:

```
gem 'omniauth-france_connect', git: "https://github.com/OpenSourcePolitics/omniauth-france_connect"
gem "omniauth-rails_csrf_protection", "~> 1.0"

```

And then execute:

```
bundle install
```

## Usage

You must create a new initializer under `config/initializers/` named as you want like `omniauth_france_connect.rb`.

__NOTE__: This initializer is made for working with [Decidim](https://github.com/decidim/decidim), you will probably need to update to match your project.

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
        env["omniauth.strategy"].options[:scope] = provider_config[:scope]&.split(" ")
      },
      scope: [:openid, :birthdate]
    )
  end
end
```

Then add new keys in your `config/secrets.yml` file like below : 
```
# config/secrets.yml
en:
    default:
        omniauth:
            france_connect:
            enabled: # Save to DB per Organization, can be set in /system interface
            client_id: # Save to DB per Organization, can be set in /system interface
            client_secret: # Save to DB per Organization, can be set in /system interface
            site_url: # Save to DB per Organization, can be set in /system interface
            scope: # Save to DB per Organization, can be set in /system interface
```

If you need a more generic way to configure this strategy please consult : 
- [OmniAuth::OpenIDConnect documentation](https://github.com/omniauth/omniauth_openid_connect/)
- or [OmniAuth documentation](https://github.com/omniauth/omniauth)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/OpenSourcePolitics/omniauth-france_connect. This project is intended to be a safe, welcoming space for collaboration.

Please, for security issue, do not open issue on Github but send an email to :

* security [at] opensourcepolitics.eu

Thanks !

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Open Source Politics.
