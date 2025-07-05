
This is an **OmniAuth strategy** for authenticating with **[Wix](https://www.wix.com/)** using **OAuth2**. It enables your Rails application to connect with Wix via OAuth, retrieve site and instance information, and authorize users securely.

---

## 💎 Installation

Add this line to your application's `Gemfile`:

```ruby
# If using a local gem path (development)
gem 'omniauth-wix', path: '../path/to/omniauth-wix'

# Or from a private/public GitHub repo:
# gem 'omniauth-wix', github: 'yourusername/omniauth-wix'

# and then
bundle install

```

## ⚙️ Usage
In your Rails app, configure OmniAuth in an initializer (config/initializers/omniauth.rb):

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wix, ENV['WIX_APP_ID'], ENV['WIX_APP_SECRET']
end

```

Set the following environment variables:

```ruby
WIX_APP_ID=your_app_id
WIX_APP_SECRET=your_app_secret
```

## 🔁 OAuth Flow
Wix will redirect to your app with a token param. You should create a route and controller action like this:

routes.rb

```ruby
get '/auth/:provider/callback', to: 'sessions#create'
get '/auth/failure', to: 'sessions#failure'
```

SessionsController
```ruby
class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    # Example: use auth.info[:email] or auth.uid
    render json: auth
  end

  def failure
    render plain: "Authentication failed"
  end
end
```

If you support Wix App Market installs via GET, handle redirection via POST:

```ruby
# app/controllers/authentications_controller.rb
def blank
  if params[:provider] == "wix"
    repost("/auth/wix", params: { provider: "wix", token: params[:token] }, options: { authenticity_token: :auto }) and return
  end

  render plain: "Not Found", status: 404
end
```




## 📦 Auth Hash Schema
The authentication data returned by OmniAuth will look like this:

```ruby
{
  provider: 'wix',
  uid: 'your_instance_id',
  info: {
    site_url: 'https://yoursite.wixsite.com',
    email: 'owner@example.com'
  },
  extra: {
    raw_info: { ...site_data... }
  },
  credentials: {
    token: 'access_token',
    refresh_token: nil,
    expires: true,
    expires_at: 1234567890
  }
}

```
