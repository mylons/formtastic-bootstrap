module FormtasticBootstrap
  module Inputs
    class SearchInput
      include Base
      include Base::Stringish
      # Formtastic 5.0 SearchInput also includes Base::Placeholder
      # include Base::Placeholder # Add if needed

      def to_html
        bootstrap_wrapping do
          builder.search_field(method, form_control_input_html_options)
        end
      end

    end
  end
end