require 'test_helper'
require 'blogeen'
require 'tmpdir'

describe Blogeen do
  describe "the instance" do
    before do
      @blogeen = Blogeen.new(Dir.mktmpdir)
    end
    
    after do
      @blogeen.rmtree
    end

    it "can be initialized" do
      @blogeen.init
      @blogeen.join("Rakefile").must_be :file?
      @blogeen.join("index.txt").must_be :file?
    end
  end
end
