require 'bundler'
Bundler.require

PORT = ENV['PORT'] || 4567

set :port, PORT

get '/api/widgets' do
  content_type :json
  Widgets.all.to_json
end

class Widgets
  def self.all
    [
      {name: 'Foo Widget', price_cents: 1567},
      {name: 'Bar Widget', price_cents: 4321}
    ]
  end
end
