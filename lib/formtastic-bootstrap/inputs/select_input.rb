module FormtasticBootstrap
  module Inputs
    # Uses mixins, not inheritance, following Formtastic 5.0 pattern
    class SelectInput
      include Base # Ensure local Base helpers are included
      include Base::Collections # Include local Collections customizations/overrides

      def to_html
        bootstrap_wrapping do
          builder.select(input_name, collection, input_options, form_control_input_html_options)
        end
      end

    end
  end
end
