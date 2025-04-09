module FormtasticBootstrap
  module Inputs
    class HiddenInput
      include Base
      # Note: HiddenInput in Formtastic 5.0 also includes Formtastic::Inputs::Base::Stringish
      # but we seem to handle wrapping differently here, so we might not need it.
      # Consider adding `include Base::Stringish` if issues arise.

      def to_html
        bootstrap_wrapping do
          builder.hidden_field(method, input_html_options)
        end
      end
    end
  end
end