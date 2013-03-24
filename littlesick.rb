require 'sinatra'

class LittleSick < Sinatra::Base
  get '/' do
    erb :filter, layout: :application
  end

  get '/results' do
    erb :results, layout: :application
  end

  get '/details' do
    erb :details, layout: :application
  end
end
