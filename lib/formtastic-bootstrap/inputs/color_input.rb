module FormtasticBootstrap
  module Inputs
    class ColorInput
      include Base
      include Base::Stringish
      include Base::Placeholder
      include Base::Html

      def input_html_options
        opts = super
        opts.delete(:maxlength)
        opts
      end

      def to_html
        raise "The :color input requires the color_field form helper, which is only available in Rails 4+" unless builder.respond_to?(:color_field)
        bootstrap_wrapping do
          builder.color_field(method, input_html_options)
        end
      end
    end
  end
end
