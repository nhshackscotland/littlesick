require 'sinatra'

class LittleSick < Sinatra::Base
  get '/' do
    erb :filter, layout: :application
  end

  get '/results' do
    @results = results
    erb :results, layout: :application
  end

  get '/details/:id' do
    service = results.find{|result| result[:_id] == params[:id]}
    @location_name = service[:location_name]
    @phone = service[:phone]
    @address = service[:address]

    erb :details, layout: :application
  end

  private

  def results
    [
      {
        _id: "514eece3005385f0cdd250f2",
        location_name: "City Centre MIU",
        distance: 3.2,
        phone: "0845 678 9107",
        address: "12 Old Dalkeith Road\nEdinburgh\nEH15 2HR",
        category: "MIU"
      }
    ]
  end
end
