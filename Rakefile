# Blogín
# ======
#
# The simplest blog creation Rakefile
# -----------------------------------
#
# Write pages and blog entries in Markdown files like my-first-page.txt.
# Run `rake`. Modify the new .yml file if you want to tweak, and run rake
# again. When you're happy, rsync/push your website.
#
# Style it by changing style.css, or theme it completely by changing
# site.html.erb. Give special pages their own template.
#
# Modify the client-side behaviour with application.js, or in the template.
#
# Start a server with rake:server, and see how it looks.
#
# Use rdoc, Markdown (with rdiscount) or Textile (with redcloth) to write your
# pages, or simply write them in HTML.
#
# Configuration
# -------------
#
# Put global overrides into site.yml, and per-page overrides into
# <my-page>.yml (which is created for you if it doesn't exist when you run
# rake).
#
# The template and layout will have a "page" object which contains the
# configuration values.
#
# To do
# -----
#
# * Refactor a little, probably using a Page class which subclasses FileTask.
# * Document properly.
$KCODE = "U" # UTF-8
require 'ostruct'
require 'erb'
require 'yaml'
require 'time'
require 'digest/md5'
require 'rake/clean'

# Index files - found by looking for index.*.erb, and removing the .erb
# suffix.
INDICES = FileList.new("index.*.erb").ext

# These files are deleted when you run `rake clean`
CLEAN.include FileList.new("**/*.txt").ext("html")
CLEAN.include INDICES
# These are also deleted when you run `rake clobber` - be careful!
CLOBBER.include FileList.new("**/*.txt").ext("yml")

# Files to build
TARGETS = FileList.new("**/*.txt").ext("html")

# Default settings - overridden by site.yml, or (for specific pages)
# <pagename>.yml.
CONFIG = {
  :title => "My Website",
  :markdown => "rdoc",
  :server => "http://localhost:8033",
  :base => "/"
}
CONFIG.merge!(YAML.load_file('site.yml')) if File.exists?('site.yml')

# A helper method, to convert text to HTML using RDoc (which is built into
# most Ruby installations).
def rdoc(text)
  require 'rdoc/markup/simple_markup' unless defined?(SM::SimpleMarkup) === "constant"
  require 'rdoc/markup/simple_markup/to_html' unless defined?(SM::ToHtml) === "constant"
  sm_p, sm_h = SM::SimpleMarkup.new, SM::ToHtml.new
  sm_p.convert(text, sm_h)
end

# A helper method to convert text to HTML (using RDiscount)
def rdiscount(text)
  require 'rubygems' unless defined?(Gem) === "constant"
  require 'rdiscount' unless defined?(RDiscount) === "constant"
  RDiscount.new(text).to_html
end

# A helper method to convert text to HTML (using RedCloth)
def redcloth(text)
  require 'rubygems' unless defined?(Gem) === "constant"
  require 'redcloth' unless defined?(RedCloth) === "constant"
  RedCloth.new(text).to_html
end

# A helper method to convert text to HTML (using Maruku)
def maruku(text)
  require 'rubygems' unless defined?(Gem) === "constant"
  require 'maruku' unless defined?(Maruku) === "constant"
  Maruku.new(text).to_html
end

# A helper method to highlight <pre>s in the HTML string with pygmentize
# and Nokogiri. Looks for a shelang (like #python) at the top, which will
# not be printed.
def pygments(html)
  require 'nokogiri' unless defined?(Nokogiri) === "constant"
  doc = Nokogiri::HTML(html)
  doc.css('pre code').each do |pre|
    h = pre.inner_text.split("\n")
    if h.shift =~ /#!?\s*(\w+)/
      result = IO.popen("pygmentize -l #$1 -f html -O nowrap=true", "r+") do |io|
        io.write(h.join("\n"))
        io.close_write
        io.read
      end
      pre.replace(result)
    end
  end
  doc.to_s
end

# The rule for building a .yml file from a .txt file
rule '.yml' => '.txt' do |t|
  page = {}
  page.merge(YAML.load_file(t.name)) if File.exists?(t.name)
  page[:source] = t.source
  page[:name] = t.name.ext("html")
  page[:path] = "#{CONFIG[:base]}#{page[:name]}"
  page[:url] = "#{CONFIG[:server]}#{page[:path]}"
  page[:lastmod] = File.mtime(t.source)
  page[:pubdate] ||= File.ctime(t.source)
  page[:title] ||= t.name.pathmap("%n").split("-").map { |s| s[0..0].upcase + s[1..-1] }.join(" ")
  page[:summary] ||= "No summary"
  File.open(t.name, "w") { |f| YAML.dump(CONFIG.merge(page), f) }
end

# The rule for building a .html file from a .yml file 
rule '.html' => '.yml' do |t|
  config = CONFIG.merge(YAML.load_file(t.source))
  page = OpenStruct.new(config)
  page.content = send(page.markdown, File.read(page.source))
  page.content = ERB.new(File.read(page.template), 0, '-').result(binding) if page.template
  page.content = send(page.highlight, page.content) if page.highlight
  page.content = ERB.new(File.read(page.layout), 0, '-').result(binding) if page.layout
  File.open(t.name, "w") { |f| f.print(page.content) }
end

# The rule for building an index.* file
index = lambda do |t|
  pages = TARGETS.map { |f| OpenStruct.new(CONFIG.merge(YAML.load_file(f.ext("yml")))) }
  page = OpenStruct.new(CONFIG.merge(:title => "Index"))
  content = ERB.new(File.read("#{t.name}.erb"), 0, '-').result(binding)
  File.open(t.name, "w") { |f| f.print(content) }
  if t.name == 'index.html' # apply the layout, too
    page = OpenStruct.new(CONFIG)
    page.content = File.read(t.name)
    File.open(t.name, "w") { |f| f.print(ERB.new(File.read(CONFIG[:layout]), 0, '-').result(binding)) }
  end
end

# Any index file will trigger a rebuild of stale targets
INDICES.each { |f| file(f => TARGETS, &index) }

# Our tasks
desc "Start a server. Options (as environment variables): PORT, ROOT, BASE"
task :server do
  require 'webrick'
  include WEBrick
  root = ENV['ROOT'] || "."
  base = ENV['BASE'] || CONFIG[:base] || '/'
  port = ENV['PORT'] || CONFIG[:port] || 8033
  server = HTTPServer.new(:Port => port)
  server.mount(base, HTTPServlet::FileHandler, root)
  Signal.trap("INT") { server.shutdown }
  server.start
end

desc <<DESC
  Rebuild the site. Basically builds the index, which builds everything. Index
  files are determined to be anything layed out with index.*.erb. So if you
  want an index.rss, you need to just create index.rss.erb in the root, and
  call this task (which happens to be the default).
DESC
task :index => INDICES

task :default => TARGETS
task :default => :index
