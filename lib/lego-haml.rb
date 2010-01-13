module Lego
  module Haml
    require 'haml'
    include ::Haml::Helpers
    
    def self.register(lego)
      lego.add_plugin :view, self
    end

    def haml(template, locals={})
      template = File.read("#{options(:views)}/#{template}.haml") if template.is_a? Symbol
      ::Haml::Engine.new(template).render(self, locals)
    end

    private
      
      def read_template(template)
        File.read File.join(options(:views)), "#{template}.haml"
      end

      def file_not_found_message
        "No views path specified, add 'set :views => <path>' to you controller"
      end
  end
end
