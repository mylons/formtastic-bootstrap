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
        puts "DEBUG: DateSelectInput#to_html"
        puts "DEBUG: self.class: #{self.class}"
        puts "DEBUG: self.class.ancestors: #{self.class.ancestors.map(&:to_s).join(', ')}"
        puts "DEBUG: respond_to?(:input_html_options): #{respond_to?(:input_html_options)}"
        
        begin
          opts = options
          puts "DEBUG: options: #{opts.keys.join(', ')}"
          
          # Check what methods are available from Formtastic
          puts "DEBUG: Formtastic::Inputs::DateSelectInput instance methods: #{Formtastic::Inputs::DateSelectInput.instance_methods(false).join(', ')}"
          puts "DEBUG: Formtastic::Inputs::Base instance methods: #{Formtastic::Inputs::Base.instance_methods(false).join(', ')}"
          
          # Check for DatetimePickerish methods
          if self.class.ancestors.include?(FormtasticBootstrap::Inputs::Base::DatetimePickerish)
            puts "DEBUG: DatetimePickerish included"
            puts "DEBUG: DatetimePickerish instance methods: #{FormtasticBootstrap::Inputs::Base::DatetimePickerish.instance_methods(false).join(', ')}"
          end
          
          super
        rescue => e
          puts "DEBUG: Error in to_html: #{e.class} - #{e.message}"
          puts "DEBUG: Backtrace: #{e.backtrace.first(10).join("\n")}"
          raise
        end
      end
      
      # Complete implementation of input_html_options
      def input_html_options
        puts "DEBUG: DateSelectInput#input_html_options called"
        
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
        
        puts "DEBUG: Final input_html_options: #{new_options.inspect}"
        new_options
      end
    end
  end
end
