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
    #     - String: Path to the view file
    #     - Symbol: Looks for a <template>.haml file in
    #               the path specified by options(:views)
    #               and renders the contents of that file
    #
    #     Example:
    #       haml "views/template.haml" #=> Renders views/template.haml
    #       haml :template             #=> Renders <view_path>/template.haml
    #
    #   <locals> is a hash of local variables to pass to the template
    #
    #     Example:
    #        haml :template, :foo => "My Header" #=> Passes the local variable foo to the view
    #
    # Instance variables are automatically made available to the view
    #
    #   Example:
    #     @foo = "My Template"
    #     haml "%h1 @foo" #=> "<h1>My Header</h1>\n"
    #
    #
    # The haml method can be used inside views to render partials
    #
    #   Example:
    #     %h1 My Template
    #     = haml :_foo               #=> Renders <view_path>/_foo.haml
    #     = haml 'views/_foo.haml'   #=> Renders views/_foo.haml
    #     = haml :foo, :foo => "foo" #=> Passes foo to the partial
    #
    #
    def haml(template, locals={})
      ::Haml::Engine.new(extract(template)).render(self, locals)
    end

    private
       
      def extract(template)
        template.is_a?(Symbol) ? read(template) : read_explicit(template)
      end

      def read(template)
        read_explicit "#{options(:views)}/#{template}.haml"
      end

      def read_explicit(file_path)
        File.read(file_path)
      end
  end
end
