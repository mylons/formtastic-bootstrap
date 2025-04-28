module FormtasticBootstrap
  module Inputs
    class DatePickerInput < Formtastic::Inputs::DatePickerInput
      include Base
      include Base::Stringish
      include Base::DatetimePickerish

      def to_html
        super
      end
      
      def input_html_options
        super
      end
    end
  end
end