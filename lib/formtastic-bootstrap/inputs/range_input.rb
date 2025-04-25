module FormtasticBootstrap
  module Inputs
    # A Bootstrap-styled range input that renders an HTML5 `<input type="range">`.
    #
    # @example Basic usage
    #   <%= f.input :rating, as: :range %>
    #
    # @example With custom min/max/step values
    #   <%= f.input :rating, as: :range, input_html: { min: 0, max: 10, step: 0.5 } %>
    #
    # @see Formtastic::Inputs::RangeInput
    class RangeInput
      include Base
      include Base::Numeric
      include Base::Stringish

      # Renders the range input with Bootstrap styling.
      # Default values are applied if not specified:
      # - min: 1 (minimum value)
      # - max: 100 (maximum value)
      # - step: 1 (increment value)
      #
      # These defaults can be overridden through:
      # - Validations on the model
      # - The :input_html option
      # - The :min, :max, or :step options
      def to_html
        bootstrap_wrapping do
          builder.range_field(method, input_html_options_with_defaults)
        end
      end

      private

      def input_html_options_with_defaults
        defaults = {
          min: 1,
          max: 100,
          step: 1
        }
        
        options = form_control_input_html_options
        defaults.each do |key, default_value|
          options[key] = default_value if options[key].nil?
        end
        options
      end

    end
  end
end