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

get "/show/:name" do
  params[:name]
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    "<p>" + text.split("\n\n").join("</p><p>") + "</p>"
  end
end