module FormtasticBootstrap
  module Inputs
    class PasswordInput
      include Base
      include Base::Stringish

      def to_html
        bootstrap_wrapping do
          builder.password_field(method, form_control_input_html_options)
        end
      end

      def input_html_options
        parent_options = super
        if builder.default_text_field_size && !parent_options.key?(:size)
          parent_options[:size] = builder.default_text_field_size
        end
        parent_options
      end
      
      # Override to ensure size attribute is preserved
      def form_control_input_html_options
        options = super
        options[:size] = input_html_options[:size] if input_html_options[:size]
        options
      end
    end
  end
end