require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @sort = params['sort']
  @sort = 'ascending' unless @sort
  @change_sort = @sort == 'ascending' ? 'descending' : 'ascending'

  @files = Dir.children("public").sort
  @files.reverse! if @sort == 'descending'

  erb :files
end

# get "/:name" do
#   @content = File.read("#{params['name']}")
#   erb :file
# end