require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'kaminari'
require 'kaminari/config'
require 'kaminari/helpers/paginator'
require 'kaminari/models/page_scope_methods'
require 'kaminari/models/configuration_methods'
require 'sinatra/url_for'
require './app/helpers/pagination_links.rb'
require 'json'
require 'jsonapi-serializers'
require 'pry'

include ::PaginationLinks

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error - ' + env['sinatra.error'].message
end

current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }
Dir["#{current_dir}/app/serializers/*.rb"].each { |file| require file }
Dir["#{current_dir}/app/services/*.rb"].each { |file| require file }

class App < Sinatra::Base
  set :show_exceptions, :after_handler
  helpers Sinatra::UrlForHelper
end

before do
  content_type :json
end

get '/' do
  ads = Ad.order(updated_at: :desc).page(params[:page])
  result = ::AdSerializer.new(ads, links: pagination_links(ads))
  JSONAPI::Serializer.serialize(result.object, is_collection: true).to_json
end

post '/ads' do
  result = CreateService.new(params).call
  if result.success?
    serializer = AdSerializer.new(result.ad)
    JSONAPI::Serializer.serialize(serializer.object, is_collection: false).to_json
  else
    halt 422, result.errors
  end
end
