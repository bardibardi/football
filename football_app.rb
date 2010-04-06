require 'sinatra/base'
require 'haml'
require 'sass'
# require 'logger'

require 'templates'
require 'table_templates'

class FootballApp < Sinatra::Base

  use Rack::Static, :urls => ['/images', '/data']

#  configure do
#    LOGGER = Logger.new("sinatra.log") 
#  end
# 
#  helpers do
#    def logger
#      LOGGER
#    end
#  end

  before do
    T.link_app(self)
    TT.link_app(self)
  end

  get '/stylesheet.css' do
    headers["Cache-Control"] = "public, max-age=900"
    content_type 'text/css', :charset => 'utf-8'
    sass :'stylesheet.css' 
  end

  get '/' do
    redirect '/games.html'
  end

  get '/ratings.html' do
    headers["Cache-Control"] = "public, max-age=900"
    T.football(T.ratings)
  end

  get '/games.html' do
    headers["Cache-Control"] = "public, max-age=900"
    T.football(T.games)
  end

  get '/table.html' do
    headers["Cache-Control"] = "public, max-age=900"
    T.football(TT.results_table_wrapper)
  end

  get '/glossary.html' do
    headers["Cache-Control"] = "public, max-age=900"
    T.football(T.glossary)
  end

  get '/about.html' do
    headers["Cache-Control"] = "public, max-age=900"
    T.football(T.about)
  end

end


