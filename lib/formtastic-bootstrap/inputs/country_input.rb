module FormtasticBootstrap
  module Inputs
    class CountryInput
      include Base
      include Base::Collections

      def to_html
        bootstrap_wrapping do
          builder.country_select(method, priority_countries, input_options, form_control_input_html_options)
        end
      end

    end
  end
end
