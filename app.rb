require "sinatra"
require "sinatra/reloader"
require "require_all"

set :bind, "0.0.0.0"

include ERB::Util

require_relative "db/db"

require_rel "controllers"
require_rel "models"
require_rel "helpers"

puts "This sinatra application is available at: https://#{Socket.gethostname}-4567.codio.io" if ENV["USER"] == "codio"
puts "This sinatra application is available at: http://localhost:4567" unless ENV["USER"] == "codio"
