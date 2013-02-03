require 'sinatra/base'
require 'slim'
require 'less'
require 'coffee-script'

class App < Sinatra::Base

	Slim::Engine.set_default_options :pretty => true

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
	
	run! if app_file == $0

end
