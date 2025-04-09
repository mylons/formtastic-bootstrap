module FormtasticBootstrap
  module Inputs
    class RangeInput
      include Base
      include Base::Numeric
      include Base::Stringish

      def to_html
        bootstrap_wrapping do
          builder.range_field(method, form_control_input_html_options)
        end
      end

    end
  end
end