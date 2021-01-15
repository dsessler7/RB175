require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherbet Homie"

  erb :home
end

get "/chapters/:number" do
  redirect "/" unless (1..@contents.size).cover?(params[:number].to_i)

  @title = "Chapter #{params[:number]}: #{@contents[params[:number].to_i - 1]}"
  @chapter = File.read("data/chp#{params[:number]}.txt")

  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

get "/show/:name" do
  params[:name]
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, index|
      "<p id=paragraph#{index}>#{paragraph}</p>"
    end.join
  end

  def boldify(text, bold_words)
    text.split(bold_words).join("<strong>#{bold_words}</strong>")
  end
end

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

# This method returns an Array of Hashes representing chapters that match the
# specified query. Each Hash contain values for its :name, :number, and
# :paragraphs keys. The value for :paragraphs will be a hash of paragraph indexes
# and that paragraph's text.
def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    paragraphs = {}
    contents.split("\n\n").each_with_index do |paragraph, index| 
      paragraphs[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: paragraphs} if contents.include?(query)
  end

  results
end

=begin
get "/search" do
  if params[:query]
    @filenames = Dir.glob('chp*', base: "./data").sort_by do |name|
      name.match(/[0-9]+/)[0].to_i
    end

    @filenames.select! do |filename|
      text = File.read("./data/#{filename}")
      text.include?(params[:query])
    end

    @titles = @filenames.map do |filename|
      @contents[filename.match(/[0-9]+/)[0].to_i - 1]
    end
  else
    @titles = []
  end

  erb :search
end

# .erb code:

<% if params[:query] && @titles.empty? %>
  <p>Sorry, no matches were found.</p>
<% end %>

<ul>
<% @titles.each_with_index do |title, index| %>
  <li><a href="/chapters/<%= @filenames[index].match(/[0-9]+/)[0] %>"><%= title %></a></li>
<% end %>
</ul>

=end
