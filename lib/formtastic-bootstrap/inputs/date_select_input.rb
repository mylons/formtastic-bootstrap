module FormtasticBootstrap
  module Inputs
    class DateSelectInput < Formtastic::Inputs::DateSelectInput
      include Base
      include Base::Stringish
      include Base::DatetimePickerish

      FRAGMENT_CLASSES = {
        :year   => "col-xs-4",
        :month  => "col-xs-5",
        :day    => "col-xs-3"
      }

      def to_html
        super
      end
      
      # Complete implementation of input_html_options
      def input_html_options
        # Start with a new hash
        new_options = {}
        
        # Add id and name
        new_options[:id] = dom_id if respond_to?(:dom_id)
        new_options[:name] = "#{object_name}[#{method}]" if respond_to?(:object_name) && respond_to?(:method)
        
        # Add standard HTML options that most inputs need
        new_options[:class] = ['form-control']
        
        # Add custom HTML options from the form builder
        if options[:input_html]
          new_options = new_options.merge(options[:input_html])
        end
        
        # Add accessibility features
        if options[:required]
          new_options[:required] = 'required'
        end
        
        # Add size attribute for date select (typically 10 chars for YYYY-MM-DD)
        new_options[:size] = options[:size] || 10
        
        # Add placeholder from options or I18n
        if options[:placeholder]
          new_options[:placeholder] = options[:placeholder]
        end
        
        new_options
      end
    end
  end
end
