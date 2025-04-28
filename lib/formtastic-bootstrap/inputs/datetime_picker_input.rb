module FormtasticBootstrap
  module Inputs
    class DatetimePickerInput < Formtastic::Inputs::DatetimePickerInput
      include Base
      include Base::Stringish
      include Base::DatetimePickerish
      
      def input_html_options
        super
      end

      def to_html
        super
      end
    end
  end
end