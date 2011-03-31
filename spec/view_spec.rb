require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PuppetDocs::View do

  before :each do
    PuppetDocs::View.instance_eval { @layout = nil }
  end

  describe ".layout=" do
    before do
      @text = "<p><%= yield %></p>"
    end
    it "should set the layout" do
      proc { PuppetDocs::View.layout = @text }.should change_layout.to(@text)
    end
  end

  describe '.layout' do
    before do
      PuppetDocs::View.stubs(:default_layout_path => fixtures_root + 'simple.html.erb')
    end
    it "should return the default layout contents" do
      PuppetDocs::View.layout.should == fixture('simple.html.erb')
    end
  end

  describe "#render" do
    describe "basic operations" do
      before do
        @text = "name"
        PuppetDocs::View.stubs(:layout => fixture('simple.html.erb'))
        @view = PuppetDocs::View.new
      end
      it "should include the content" do
        @view.render(@text).should include(@text)
      end
      it "should surround it with the layout" do
        @view.render(@text).strip.should == "<html><body>#{@text}</body></html>"
      end
    end
    describe "setting instance variables" do
      before do
        @text = "name: <%= @name %>"
        PuppetDocs::View.stubs(:layout => fixture('simple.html.erb'))
        @name = "Bruce"
        @view = PuppetDocs::View.new
        @view.set :name, @name
      end
      it "should include the content" do
        @view.render(@text).should include("name: Bruce")
      end
      it "should surround it with the layout" do
        @view.render(@text).strip.should == "<html><body>name: Bruce</body></html>"
      end
    end
    describe "allowing yield semantics" do
      before do
        @text = "name: <%= yield :name %>"
        PuppetDocs::View.stubs(:layout => fixture('simple.html.erb'))
        @name = "Bruce"
        @view = PuppetDocs::View.new
        @view.set :name, @name
      end
      it "should include the instance variable" do
        @view.render(@text).should include("name: Bruce")
      end
      it "should surround it with the layout" do
        @view.render(@text).strip.should == "<html><body>name: Bruce</body></html>"
      end
    end
    describe "with helpers" do
      before do
        @text = "<%= ticket 100 %>"
        PuppetDocs::View.stubs(:layout => fixture('simple.html.erb'))
        @view = PuppetDocs::View.new
        @view.set :name, @name
      end
      it "should call helpers" do
        @view.render(@text).should include('<a ')
        @view.render(@text).should include('100')
      end
    end
  end

end
