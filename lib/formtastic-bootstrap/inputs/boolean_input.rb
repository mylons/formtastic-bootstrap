# TODO See if this can be refactored to make use of some of the Choices code.
module FormtasticBootstrap
  module Inputs
    class BooleanInput
      include Base # Includes Formtastic::Inputs::Base + local bootstrap base modules
      # REMOVED: include Formtastic::Inputs::BooleanInput # This is a Class, cannot include

      # --- Copied public methods from Formtastic 5.0 BooleanInput --- 

      def unchecked_value
        options[:unchecked_value] || '0'
      end

      def checked_value
        options[:checked_value] || '1'
      end

      def checked?
        !object.nil? && object.respond_to?(method) && boolean_checked?(object.send(method), checked_value) 
      end
      
      def check_box_html
        # Use standard check_box_tag(name, value, checked, options)
        # Get the final name (either default or from input_html) from the options hash
        final_options = input_html_options
        tag_name = final_options[:name]
        # Pass options *without* :name to avoid confusion/duplication
        template.check_box_tag(tag_name, checked_value, checked?, final_options.except(:name))
      end

      # Copied input_html_options and name helper
      def input_html_options
        # Reverse merge order: options from super (incl. :input_html) take precedence
        {:name => input_html_options_name}.merge(super)
      end

      def input_html_options_name
        if builder.options.key?(:index)
          "#{object_name}[#{builder.options[:index]}][#{method}]"
        else
          "#{object_name}[#{method}]"
        end
      end
      
      # REMOVED label_text_with_embedded_checkbox - Logic moved to label_with_nested_checkbox
      # def label_text_with_embedded_checkbox
      #   check_box_html << +"" << label_text
      # end
      
      # Add method to prevent global required setting from adding HTML attribute
      def responds_to_global_required?
        false
      end
      
      # --- End Copied public methods --- 

      # --- FormtasticBootstrap Specific Methods / Overrides --- 

      # Skip rendering of .form-label in #bootstrap_wrapping
      def render_label?
        false
      end

      # Override to_html for Bootstrap structure
      def to_html
        bootstrap_wrapping do
          hidden_field_html <<
          label_with_nested_checkbox
        end
      end

      # Keep hidden_field_html method (now uses copied unchecked_value)
      def hidden_field_html
        template.hidden_field_tag(input_html_options[:name], unchecked_value, :id => nil, :disabled => input_html_options[:disabled] )
      end

      # Modified to construct content directly and ensure html_safe
      def label_with_nested_checkbox 
        content = (check_box_html << +"" << label_text).html_safe
        options = label_html_options
        # Use the builder's label helper
        builder.label(method, content, options)
      end
      
      # Override label_html_options: let super handle classes, just set :for.
      def label_html_options
        super.tap do |opts|
          # Base::Labelling#label_html_options (called via super) already
          # removes 'label' and adds 'control-label'.
          # We only need to ensure the :for attribute is correct.
          opts[:for] = input_html_options[:id] if input_html_options[:id]
        end
      end

      # Override wrapper_html_options for Bootstrap classes
      def wrapper_html_options
        super.tap do |options|
          options[:class] = (options[:class].to_s.split + ["checkbox"]).join(" ")
        end
      end

      # --- Private Helper Methods --- 

      private

      # Copied from Formtastic 5.0 source
      def boolean_checked?(value, checked_value)
        case value
        when TrueClass, FalseClass
          value
        when NilClass
          false
        when Integer
          value == checked_value.to_i
        when String
          value == checked_value
        when Array
          value.include?(checked_value)
        else
          value.to_i != 0
        end
      end

    end
  end
end
