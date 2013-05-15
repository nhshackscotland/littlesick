require 'sinatra'
require 'json'
require 'rest_client'

class LittleSick < Sinatra::Base
  SERVICE_LIMIT = 10

  enable :sessions

  before do
    session[:ll] = params[:ll] if params.has_key?('ll')
    session[:categories] = params[:categories] if params.has_key?('categories')
  end

  helpers do
    def simple_format(text, html_options={}, options={})
      text = '' if text.nil?
      text = text.dup
      start_tag = tag('p', html_options, true)
      text = text.to_str
      text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
      text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
      text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
      text.insert 0, start_tag
      text.concat("</p>")
    end
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

  def tag(name, options = nil, open = false, escape = true)
    "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}"
  end

  def tag_options(options, escape = true)
    unless options.empty?
      attrs = []
      options.each_pair do |key, value|
        if key.to_s == 'data' && value.is_a?(Hash)
          value.each do |k, v|
            if !v.is_a?(String) && !v.is_a?(Symbol)
              v = v.to_json
            end
            v = ERB::Util.html_escape(v) if escape
            attrs << %(data-#{k.to_s.dasherize}="#{v}")
          end
        elsif BOOLEAN_ATTRIBUTES.include?(key)
          attrs << %(#{key}="#{key}") if value
        elsif !value.nil?
          final_value = value.is_a?(Array) ? value.join(" ") : value
          final_value = ERB::Util.html_escape(final_value) if escape
          attrs << %(#{key}="#{final_value}")
        end
      end
      " #{attrs.sort * ' '}" unless attrs.empty?
    end
  end
end
