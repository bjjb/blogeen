# JJ's Rakefile
# Converts Markdown text files to HTML.
require 'erb'
require 'rubygems'
require 'rdiscount'
require 'rake/clean'

HERE = Rake.original_dir
Dir["#{HERE}/*.rake"].each do |rakefile|
  load rakefile
end

namespace :website do
  LAYOUT_FILE = "#{HERE}/layout.html.erb"
  LAYOUT = if File.exists?(LAYOUT_FILE)
    File.read(LAYOUT_FILE)
  else
  <<ERB
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <link rel='stylesheet' type='text/css' href='/style.css' />
    <title><%= title %></title>
  </head>
  <body>
    <%= html %>
  </body>
</html>
ERB
  end

  TXT = FileList["#{HERE}/**/*.txt"]
  YML = TXT.ext('yml')
  HTML = TXT.ext('html')

  CLEAN.include("#{HERE}/**/*.html")

  rule '.html' => '.yml' do |rule|
    y = YAML.load(File.read(rule.source))
    y['html'] = RDiscount.new(y['content']).to_html
    erb = ERB.new(LAYOUT)
    html = erb.result(OpenStruct.new(y).send(:binding))
    File.open(rule.name, 'w') do |f|
      f.print(html)
    end
  end

  rule '.yml' => '.txt' do |rule|
    text = File.read(rule.source)
    y = File.exists?(rule.name) ? YAML.load(File.read(rule.name)) : {}
    y['title'] ||= File.basename(rule.name, '.yml').split('-').join(' ')
    y['content'] = text
    y['description'] ||= text.split("\n\n")[1].gsub("\n", " ")
    y['author'] ||= ENV['USER']
    File.open(rule.name, 'w') do |f|
      YAML.dump(y, f)
    end
  end

  desc "Build HTML files from the current directory"
  task :build => HTML
end

desc "Build the HTML pages"
task :website => "website:build"
