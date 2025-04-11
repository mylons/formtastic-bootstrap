module FormtasticBootstrap
  module Inputs
    module Base
      module Stringish

        include Formtastic::Inputs::Base::Stringish

        def to_html
          bootstrap_wrapping do
            builder.text_field(method, form_control_input_html_options)
          end
        end

        def input_html_options
          parent_options = super
          options = { :maxlength => maxlength }
          options[:size] = size unless parent_options.key?(:size)
          parent_options.merge(options)
        end
        
        # Override form_control_input_html_options in Base::Html to ensure the size attribute is preserved
        def form_control_input_html_options
          options = super
          options[:size] = input_html_options[:size] if input_html_options[:size]
          options
        end

      end
    end
  end
end
