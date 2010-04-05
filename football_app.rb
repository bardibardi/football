require 'sinatra/base'
# require 'logger'

require 'templates'
require 'table_templates'

class FootballApp < Sinatra::Base

  use Rack::Static, :urls => ['/images']

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
    content_type 'text/css', :charset => 'utf-8'
    sass :'stylesheet.css' 
  end

  get '/' do
    redirect '/games.html'
  end

  get '/ratings.html' do
    T.football(T.ratings)
  end

  get '/games.html' do
    T.football(T.games)
  end

  get '/table.html' do
    T.football(TT.results_table_wrapper)
  end

  get '/glossary.html' do
    T.football(T.glossary)
  end

  get '/about.html' do
    T.football(T.about)
  end

end


