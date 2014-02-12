# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'date'

Gem::Specification.new do |s|
  s.name        = "loveos-config"
  s.version     = '0.0.2'
  s.date        = Date.today.to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["JJ Buckly"]
  s.email       = ["jj@bjjb.org"]
  s.homepage    = "http://github.com/bjjb/blogeen"
  s.summary     = %q{Another static blog generator}
  s.description = <<-DESC
A little tool for turning text files into a blog.
  DESC

  s.files         = `git ls-files`.split("\n") - [".gitignore"]
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = ['blogeen']
  s.require_paths = ["lib"]
end
