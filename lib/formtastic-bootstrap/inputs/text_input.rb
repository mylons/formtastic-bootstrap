module FormtasticBootstrap
  module Inputs
    class TextInput
      include Base
      include Base::Placeholder
      include Base::Stringish
      
      def to_html
        bootstrap_wrapping do
          builder.text_area(method, form_control_input_html_options)
        end
      end
      
      def input_html_options
        options = super
        
        # Use the same implementation from Formtastic
        options[:cols] = builder.default_text_area_width  if builder.default_text_area_width.present?  && !options.key?(:cols)
        options[:rows] = builder.default_text_area_height if builder.default_text_area_height.present? && !options.key?(:rows)
        
        # Remove nil values
        options.delete(:cols) if options[:cols].nil?
        options.delete(:rows) if options[:rows].nil?
        
        options
      end
    end
  end
end
