require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def app
  Class.new(Lego::Controller) do
    set :views => File.join(File.dirname(__FILE__), 'views')

    get "/string" do
      haml "%h1 My Header"
    end

    get "/instance_variables" do
      @foo = "foo"

      haml "%h1= @foo"
    end

    get "/string/with/locals" do
      haml "%h1= foo", :foo => "foo"
    end

    get "/file" do
      haml :template
    end

    get "/file/with/locals" do
      haml :file_with_locals, :foo => "foo"
    end

    get '/partial' do
      haml :partial
    end

    get '/partial/with/path' do
      haml :explicit_partial
    end
  end
end

describe "Lego Haml" do
  it "should render a string of haml as html" do
    get '/string'
    last_response.body.should eql("<h1>My Header</h1>\n")
  end

  it "should render .haml files when passed a symbol" do 
    get '/file'

    last_response.body.should eql("<h1>My Header</h1>\n")
  end

  it "should have access to instance variables" do
    get "/instance_variables"

    last_response.body.should eql("<h1>foo</h1>\n")
  end

  it "should render a string template with locals passed in" do
    get '/string/with/locals'

    last_response.body.should eql("<h1>foo</h1>\n")
  end

  it "should render a file template with locals passed in" do
    get '/file/with/locals'

    last_response.body.should eql("<h1>foo</h1>\n")
  end

  it "should render partials" do
    get '/partial'

    last_response.body.should eql("<h1>Partial</h1>\n<p>content loaded from partial</p>\n")
  end

  it "should render partials with explicit path" do
    get '/partial/with/path'

    last_response.body.should eql("<h1>Partial</h1>\n<p>content loaded from partial</p>\n")
  end
end
