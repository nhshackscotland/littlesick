require 'sinatra'
require 'json'

class LittleSick < Sinatra::Base
  SERVICE_LIMIT = 5
  EARTH_RADIUS  = 3960.0 # for distance calcs

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
    @services = all_services_with_distance
    erb :list
  end

  get '/map' do
    erb :map
  end

  get '/details/:id' do
    @service = find_service(params[:id])
    erb :details
  end

  get "/data.json" do
    content_type :json
    all_services.to_json
  end

  private

  # change to index API call
  def get_services
    File.read('data/services.json')
  end

  # change to show API call
  def get_service(id)
    all_services.find{|service| service["_id"] == id}.to_json
  end

  def all_services
    JSON.parse(get_services)
      .sort{|a,b| a[:geo_near_distance] <=> b[:geo_near_distance] }
      .take(SERVICE_LIMIT)
  end

  def all_services_with_distance
    position = session[:ll].split(',').map(&:to_f)
    all_services.each do |service|
      service["distance"] = distance(position, service["location"])
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
      { key: "GPP",  name: "GP",        class: category_class('GPP') },
      { key: "PHA",  name: "Pharmacy",  class: category_class('PHA') }
    ]
  end

  def category_class(key)
    return nil if session[:categories] && !session[:categories].match(/#{key}/)
    'active'
  end

  def distance(coords_1, coords_2)
    lat_1, lon_1 = coords_1
    lon_2, lat_2 = coords_2 # mongoDb returns backwards coords

    # fancy calculations courtesy of http://www.johndcook.com/lat_long_distance.html

    phi_1 = (90.0 - lat_1) * Math::PI / 180.0
    phi_2 = (90.0 - lat_2) * Math::PI / 180.0

    theta_1 = lon_1 * Math::PI / 180.0
    theta_2 = lon_2 * Math::PI / 180.0

    distance = EARTH_RADIUS * Math.acos(
      Math.sin(phi_1) * Math.sin(phi_2) * Math.cos(theta_1 - theta_2) + Math.cos(phi_1) * Math.cos(phi_2)
    )

    distance.round(2)
  end
end
