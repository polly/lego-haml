module Lego
  module Haml
    require 'haml'
    include ::Haml::Helpers
    
    #
    # Register the plugin with the Lego runtime
    #
    def self.register(lego)
      lego.add_plugin :view, self
    end

    #
    # Method for rendering haml input as html.
    #   <template> can be either a string or a symbol
    #     - String: Renders the string and returns html
    #     - Symbol: Looks for a <template>.haml file in
    #               the path specified by options(:views)
    #               and renders the contents of that file
    #
    #     Example:
    #       haml "%h1 My Header" #=> "<h1>My Header</h1>\n"
    #       haml :template       #=> Renders <view_path>/template.haml
    #
    #   <locals> is a hash of local variables to pass to 
    #            the template
    #
    #     Example:
    #        haml "%h1 foo", :foo => "My Header" #=> "<h1>My Header</h1>\n"
    #
    # Instance variables are automatically made available to the view
    #
    #   Example:
    #     @foo = "My Template"
    #     haml "%h1 @foo" #=> "<h1>My Header</h1>\n"
    #
    def haml(template, locals={})
      template = read_template(template) if template.is_a? Symbol
      ::Haml::Engine.new(template).render(self, locals)
    end

    private
      
      def read_template(template)
        File.read("#{options(:views)}/#{template}.haml")
      end
  end
end
