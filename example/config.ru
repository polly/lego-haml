require 'rubygems'
require 'lego-core'
require File.join(Dir.pwd, '..', 'lib', 'lego', 'haml')

module ControllerPlugin

  def self.register(lego)
    lego.add_plugin :router, Matcher
    lego.add_plugin :controller, Routes
  end

  module Routes
    def get(path, &block)
      add_route(:get, {:path => path, :action_block => block})
    end
  end

  module Matcher
    def self.match_route(route, env)
      (route[:path] == env['PATH_INFO']) ? true : false
    end
  end
end

Lego.config do
  set :views => File.join(Dir.pwd, 'views')
  plugin ControllerPlugin
  plugin Lego::Haml
end

class MyApp < Lego::Controller

  get "/" do
    haml :index
  end
end

run MyApp
