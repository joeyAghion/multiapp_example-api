require 'bundler'
Bundler.require

PORT = ENV['PORT'] || 4567

set :port, PORT

authorized_keys = []

use Rack::Auth::Basic, "Restricted Area" do |api_key, _|
  $stderr.puts "BASIC : #{api_key}"
  authorized_keys.include?(api_key)
end

before { content_type :json }

get '/api/widgets' do
  Widgets.all.to_json
end

post '/api/clients' do
  client = { key: SecureRandom.hex(32) }
  authorized_keys << client[:key]
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
