require 'sinatra'
require 'json'
require 'rest_client'

class LittleSick < Sinatra::Base
  SERVICE_LIMIT = 5

  enable :sessions

  before do
    session[:ll] = params[:ll] if params.has_key?('ll')
    session[:categories] = params[:categories] if params.has_key?('categories')
  end

  get '/' do
    @categories = categories
    erb :filter
  end

  get '/list' do
    @services = all_services
    erb :list
  end

  get '/map' do
    erb :map
  end

  get '/details/:id' do
    @service = find_service(params[:id])
    erb :details
  end

  get '/data.json' do
    content_type :json
    all_services.to_json
  end

  private
  def get_services
    url = "#{ENV['API_URL']}/services/search.json?"
    url += "ll=#{session[:ll]}"

    if session[:categories] && session[:categories] != ''
      url += "&categories=#{session[:categories]}"
    end

    RestClient.get(url)
  end

  def get_service(id)
    RestClient.get("#{ENV['API_URL']}/services/#{id}.json")
  end

  def all_services
    JSON.parse(get_services).take(SERVICE_LIMIT).each do |service|
      service['geo_near_distance'] = service['geo_near_distance'].round(2)
    end
  end

  def find_service(id)
    JSON.parse(get_service(id))
  end

  # helper schmelpers
  def categories
    [
      { key: "HOS",  name: "Hospital",  class: category_class('HOS') },
      { key: "AAE",  name: "A&E",       class: category_class('AAE') },
      { key: "MIU",  name: "MIU",       class: category_class('MIU') },
      { key: "GP",   name: "GP",        class: category_class('GP')  },
      { key: "PHA",  name: "Pharmacy",  class: category_class('PHA') }
    ]
  end

  def category_class(key)
    if session[:categories] && !session[:categories].match(/#{key}/)
      'unselected'
    else
      'selected'
    end
  end
end
