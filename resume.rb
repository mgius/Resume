#!/usr/bin/env ruby
# An app for displaying one's resume

begin
   require "rubygems"
rescue LoadError
   puts "Please install Ruby Gems to continue."
   exit
end

# Check all of the gems we need are there.
[
   "sinatra",
   "less",
   "github/markup",
   "yaml"
].each {|gem|
   begin
      require gem
   rescue LoadError
      puts "The gem #{gem} is not installed.\n"
      exit
   end
}


configure do
   set :config, YAML.load_file('config.yaml')['user_config']
end

get '/index.html' do
   rfile = settings.config['file']
   name  = settings.config['name']
   title = "#{name}'s Resume"
   resume = GitHub::Markup.render(rfile, File.read(rfile))
   erb :index, :locals => { 
      :title => title, 
      :resume => resume,
      :author => name,
      :key => settings.config['gkey'],
      :filename => rfile
   }
end

get '/' do
   redirect '/index.html'
end

get '/resume.txt' do
   content_type 'text/plain', :charset => 'utf-8'
   File.read(settings.config['file'])
end


get '/style.css' do
   content_type 'text/css', :charset => 'utf-8'
   less :style
end

get '/print.css' do
   content_type 'text/css', :charset => 'utf-8'
   less :print
end

