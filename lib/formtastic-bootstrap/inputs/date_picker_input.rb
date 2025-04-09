module FormtasticBootstrap
  module Inputs
    class DatePickerInput < Formtastic::Inputs::DatePickerInput
      include Base
      include Base::Stringish
      include Base::DatetimePickerish

      def to_html
        puts "DEBUG: DatePickerInput#to_html"
        puts "DEBUG: self.class: #{self.class}"
        puts "DEBUG: self.class.ancestors: #{self.class.ancestors.map(&:to_s).join(', ')}"
        puts "DEBUG: respond_to?(:input_html_options): #{respond_to?(:input_html_options)}"
        puts "DEBUG: method(:input_html_options).source_location: #{method(:input_html_options).source_location rescue 'Not found'}"
        
        super
      end
      
      def input_html_options
        puts "DEBUG: DatePickerInput#input_html_options"
        puts "DEBUG: superclass: #{self.class.superclass}"
        puts "DEBUG: superclass.instance_methods.include?(:input_html_options): #{self.class.superclass.instance_methods.include?(:input_html_options)}"
        
        super
      end
    end
  end
end