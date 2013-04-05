require 'sinatra'
require 'sinatra/content_for'
require 'json'

class LittleSick < Sinatra::Base
  helpers Sinatra::ContentFor

  enable :sessions

  get '/' do
    @categories = [
      { key: "HOS", name: "Hospital", class: category_class('HOS') },
      { key: "AAE", name: "A&E", class: category_class('AAE') },
      { key: "MIU", name: "MIU", class: category_class('MIU') },
      { key: "GPP", name: "GP", class: category_class('GPP') },
      { key: "PHA", name: "Pharmacy", class: category_class('PHA') }
    ]
    erb :filter, layout: :application
  end

  get '/map' do
    @services = results.to_json
    erb :map, layout: :application
  end

  get '/results' do
    session[:ll] = params[:ll] if params.has_key?('ll')
    session[:categories] = params[:categories] if params.has_key?('categories')

    @results = results
    position = session[:ll].split(',').map(&:to_f)
    @results.each do |result|
      result["distance"] = distance(position, result["location"])
    end
    erb :results, layout: :application
  end

  get '/details/:id' do
    service = results.find{|service| service["_id"] == params[:id]}
    @location_name = service["location_name"]
    @phone = service["phone"]
    @address = service["address"]
    @category = service["category"]

    erb :details, layout: :application
  end

  get "/data.json" do
    content_type :json
    results.to_json
  end

  private

  def category_class(key)
    if session[:categories]
      if session[:categories].split(',').include?(key)
        'active'
      else
        ''
      end
    else
      'active'
    end
  end

  def results
    JSON.parse(File.read('data/services.json'))
      .sort{|a,b| a[:geo_near_distance] <=> b[:geo_near_distance] }
      .take(5)
  end

  RHO = 3960.0 # earth diameter in miles

  def distance(coords_1, coords_2)
    lat_1, lon_1 = coords_1
    lon_2, lat_2 = coords_2 # stupid mongoDb returns backwards coords

    # convert latitude and longitude to spherical coordinates in radians

    # phi = 90 - latitude
    phi_1 = (90.0 - lat_1) * Math::PI / 180.0
    phi_2 = (90.0 - lat_2) * Math::PI / 180.0

    # theta = longitude
    theta_1 = lon_1 * Math::PI / 180.0
    theta_2 = lon_2 * Math::PI / 180.0

    # compute spherical distance from spherical coordinates

    # arc length = \arccos(\sin\phi\sin\phi'\cos(\theta-\theta') + \cos\phi\cos\phi')
    # distance = rho times arc length
    distance = RHO * Math.acos(
      Math.sin(phi_1) * Math.sin(phi_2) * Math.cos(theta_1 - theta_2) + Math.cos(phi_1) * Math.cos(phi_2)
    )

    # get rid of superfluous precision
    distance.round(2)
  end
end
