module FormtasticBootstrap
  module Inputs
    module Base
      module Labelling
        extend ActiveSupport::Concern
        
        # Include the core Formtastic module - only once
        # It might not define label_html_options, but could define others we need.
        include Formtastic::Inputs::Base::Labelling

        def label_html_options
          
          with_deprecation_silenced do
            # Implement the necessary logic directly.
            options = {}
            
            # Use input_dom_id, which should be available from included Formtastic modules,
            # to generate the correct ID for the 'for' attribute.
            options[:for] = input_dom_id if respond_to?(:input_dom_id)
            
            options[:class] = [] # Start with an empty array

            # Get the input options to check for a custom :id provided by the user
            input_opts = {} # Default to empty hash
            begin
              input_opts = input_html_options if respond_to?(:input_html_options)
            rescue => e
              puts "DEBUG: Error getting input_html_options: #{e.class} - #{e.message}"
              puts "DEBUG: Backtrace: #{e.backtrace.first(5).join("\n")}"
            end

            # If a custom id is provided via :input_html, it takes precedence
            if input_opts && input_opts[:id]
              options[:for] = input_opts[:id]
            end

            # Adjust classes for Bootstrap
            options[:class] << "control-label"
            options[:class].uniq! # Avoid duplicate classes

            options # Return the constructed hash
          end
        end

        def label_html
          if render_label?
            begin
              label_options = label_html_options
            rescue => e
              label_options = {:class => "control-label"} # Minimal fallback
            end
            
            template.content_tag(:span, :class => 'form-label') do
              begin
                builder.label(method, label_text, label_options)
              rescue => e
                "Label Error".html_safe # Basic error display
              end
            end
          else
            "".html_safe
          end
        end

      end
    end
  end
end
