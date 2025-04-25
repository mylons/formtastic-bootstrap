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
              # Log error if needed, but don't stop execution
            end

            # If a custom id is provided via :input_html, it takes precedence
            if input_opts && input_opts[:id]
              options[:for] = input_opts[:id]
            # For select inputs with associations, ensure proper ID format
            elsif is_select_input_with_association?
              options[:for] = association_input_dom_id
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
              # Log the error for debugging
              warn "Error generating label options: #{e.message}\n#{e.backtrace.join("\n")}"
              label_options = {:class => "control-label"} # Minimal fallback
            end
            
            template.content_tag(:span, :class => 'form-label') do
              builder.label(method, label_text, label_options)
            end
          else
            "".html_safe
          end
        end
        
        # Check if this is a select input with an association
        def is_select_input_with_association?
          self.class.to_s.include?("SelectInput") && reflection
        end
        
        # Generate the proper DOM ID for association-based inputs
        def association_input_dom_id
          if reflection && reflection.macro == :belongs_to
            "#{object_name}_#{association_primary_key || method}_id"
          elsif reflection && [:has_many, :has_and_belongs_to_many].include?(reflection.macro)
            "#{object_name}_#{(association_primary_key || method.to_s.singularize)}_ids"
          else
            input_dom_id
          end
        end
        
        # Extract association primary key name (without _id suffix)
        def association_primary_key
          if reflection && reflection.macro == :belongs_to
            method.to_s.sub(/_id$/, '')
          end
        end

      end
    end
  end
end
