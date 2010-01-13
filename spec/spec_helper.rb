$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'lego/haml'
require 'lego-core'
require 'rack/test'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods 
end

module Routes
  def self.register(lego)
    lego.add_plugin :controller, SinatraController
    lego.add_plugin :router,     SimpleRouter
  end

  # implements a basic Sinatra inspiered dsl
  module SinatraController
    def get(path, &block)
      add_route(:get, {:path => path, :action_block => block})
    end
  end

  # Implements a very basic mather rule
  module SimpleRouter
    def self.match_route(route, env)
      (route[:path] == env['PATH_INFO']) ? true : false
    end
  end
end

Lego.config do
  plugin Routes
  plugin Lego::Haml
end
