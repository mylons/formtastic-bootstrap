module FormtasticBootstrap
  module Inputs
    class TextInput
      include Base
      include Base::Placeholder
      
      def to_html
        bootstrap_wrapping do
          builder.text_area(method, form_control_input_html_options)
        end
      end

    end
  end
end
