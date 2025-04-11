module FormtasticBootstrap
  module Inputs
    class HiddenInput
      include Formtastic::Inputs::Base
      include Base::Html
      include Base::Wrapping
      include Base::Hints
      include Base::Errors

      def to_html
        bootstrap_wrapping do
          builder.hidden_field(method, input_html_options)
        end
      end

      def input_html_options
        super.tap do |options|
          options.delete(:autofocus)
        end
      end

      def error_list_html(ignore)
        ""
      end
    end
  end
end