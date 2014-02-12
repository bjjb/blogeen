require 'pathname'
require 'yaml'

# A Blogeen is a directory. Therefore, it simply a decorated Pathname.
class Blogeen < Pathname
  def initialize(dir)
    super(File.expand_path(dir))
  end

  # Populate the new directory (provided it hasn't already been inited)
  def init
    if exist?
      raise "#{self} is not a directory" unless directory?
    else
      mkdir
    end

    rakefile = join("Rakefile")
    if rakefile.exist?
      puts "Looks like that site is already initialized."
    else
      src = Pathname.new(__FILE__).join("../../blogeen.rake")
      rakefile.open("w").print(src.read)
    end

    unless join('index.txt').exist?
      join('index.txt').open('w').print "My Homepage"
    end
  end
end
