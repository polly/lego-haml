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
    #   <locals> is a hash of local variables to pass to the template
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
      ::Haml::Engine.new(extract(template)).render(self, locals)
    end
    
    #
    # Method for rendering partials.
    #
    #  <partial> - A symbol representing the filename or a string representing the 
    #              relative path and the full filename.
    #
    #    Example:
    #       %h1 My Template
    #       = partial :foo # renders <view_path>/_foo.haml
    #       = partial "views/_foo.haml"
    #
    #  <locals> - is a hash of local variables to pass to the template
    #
    #    Example:
    #       %h1 My Template
    #       = partial :foo, :my_var => "my var" # my_var will be locally available 
    #                                           # inside the partial template
    #
    def partial(partial, locals={})
      partial = partial.is_a?(String) ? read_from(partial) : read("_#{partial}")
      ::Haml::Engine.new(partial).render self, locals
    end

    private
       
      def extract(template)
        template.is_a?(Symbol) ? read(template) : template
      end

      def read(template)
        read_from "#{options(:views)}/#{template}.haml"
      end

      def read_from(file_path)
        File.read(file_path)
      end
  end
end
