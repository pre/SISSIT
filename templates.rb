require 'rubygems'
require 'sinatra'
require 'haml'

configure do
  set :haml, {:format => :html5 } # default Haml format is :xhtml
  VIEW_FOLDER = "views"
  HAML_SUFFIX = ".haml"
  HTML_SUFFIX = ".html"
end

not_found do
  haml :error_404, :locals => {:page_name => params[:page_name]}
end

# One method to rule them all.
# If request URI is e.g. "/flowers", first one of the following will
# be rendered from views/ directory if the corresponding file exists.
# 1) flowers.haml
# 2) flowers.html (also URI /flowers.html will match this)
# 3) Error 404 if no matching file was found.
get '/:page_name' do
  content_file = File.join(VIEW_FOLDER, "#{params[:page_name]}")
  if File.exists?(content_file + HAML_SUFFIX)
    haml params[:page_name].to_sym
  elsif File.exists?(content_file + HTML_SUFFIX)
    File.open(content_file + HTML_SUFFIX).read
  elsif File.exists?(content_file)
    File.open(content_file).read
  else
    halt 404 # handled in method "not_found"
  end
end

get '/' do
  haml :index
end