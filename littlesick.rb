require 'sinatra'

class LittleSick < Sinatra::Base
  get '/' do
    erb :filter, layout: :application
  end

  get '/map' do
    erb :map, layout: :application
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
    @category = service[:category]

    erb :details, layout: :application
  end

  private

  def results
    # REPLACE WITH REAL DATA!!
    [
      {
        _id: "514eece3005385f0cdd250f2",
        location_name: "City Centre MIU",
        distance: 3.2,
        phone: "0845 678 9107",
        address: "3 Cowgate\nEdinburgh\nEH02 2RT",
        category: "MIU"
      },
      {
        _id: "314eece3005385f0cdd250f2",
        location_name: "Royal A&E",
        distance: 2.1,
        phone: "0131 678 9107",
        address: "12 Old Dalkeith Road\nEdinburgh\nEH15 2HR",
        category: "AAE"
      },
      {
        _id: "714eece3005385f0cdd250f2",
        location_name: "Liberton MIU",
        distance: 2.8,
        phone: "0131 578 9330",
        address: "58 Liberton Road\nEdinburgh\nEH15 2HR",
        category: "MIU"
      },
      {
        _id: "814eece3005385f0cdd250f2",
        location_name: "Western General Hospital",
        distance: 3.8,
        phone: "0131 478 0077",
        address: "Queensferry Road\nEdinburgh\nEH15 2HR",
        category: "HOS"
      },
    ].sort{|a,b| a[:distance] <=> b[:distance] }
  end
end
