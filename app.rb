require 'bundler'
Bundler.require

PORT = ENV['PORT'] || 4567

set :port, PORT

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && Clients.authorized_keys.include?(@auth.credentials.first)
  end
end

before { content_type :json }

get '/api/widgets' do
  protected!
  Widgets.all.to_json
end

post '/api/clients' do
  client = { key: SecureRandom.hex(32) }
  Clients.authorized_keys << client[:key]
  client.to_json
end

class Widgets
  def self.all
    [
      {name: 'Foo Widget', price_cents: 1567},
      {name: 'Bar Widget', price_cents: 4321}
    ]
  end
end

class Clients
  def self.authorized_keys
    @@authorized_keys ||= []
  end
end
