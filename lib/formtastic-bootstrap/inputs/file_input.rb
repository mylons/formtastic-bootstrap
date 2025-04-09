module FormtasticBootstrap
  module Inputs
    class FileInput
      include Base

      # FileInput in Formtastic 5.0 also includes Base::Stringish
      # We seem to have custom wrapping, check if Base::Stringish is needed.

      def to_html
        bootstrap_wrapping do
          builder.file_field(method, input_html_options)
        end
      end
    end
  end
end