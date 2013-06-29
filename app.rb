require 'sinatra/base'
require 'slim'
require 'less'
require 'coffee-script'
require 'sinatra/partial'
require 'rdiscount'
require 'yaml'

class App < Sinatra::Base

  configure do
    Slim::Engine.set_default_options :pretty => true
    register Sinatra::Partial
    set :partial_template_engine, :slim
  end

  register do
    def check (name)
      condition do
        error 401 unless send(name) == true
      end
    end
  end

  helpers do
    def valid_key?
      params[:key] == "1234"
    end
  end

  get '/css/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    filename = "#{params[:name]}"
    render :less, filename.to_sym, :layout => false, :views => './public/css'
  end

  get '/js/:name.js' do
    content_type 'text/javascript', :charset => 'utf-8'
    filename = "#{params[:name]}"
    render :coffee, filename.to_sym, :layout => false, :views => './public/js'
  end


  get '/', :check => :valid_key? do
    slim :index
  end

  get '/:post', :check => :valid_key? do
    file = "content/#{params[:post]}/#{params[:post]}"
    markdown = RDiscount.new(File.read(file + ".md")).to_html
    slim :post, :locals => { :text => markdown }

  end

  run! if app_file == $0

end
