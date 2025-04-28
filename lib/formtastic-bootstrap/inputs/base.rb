require "formtastic-bootstrap/inputs/base/errors"
require "formtastic-bootstrap/inputs/base/hints"
require "formtastic-bootstrap/inputs/base/html"
require "formtastic-bootstrap/inputs/base/labelling"

module FormtasticBootstrap
  module Inputs
    module Base
      extend ActiveSupport::Autoload
      include Formtastic::Inputs::Base

      autoload :DatetimePickerish,  "formtastic-bootstrap/inputs/base/datetime_pickerish"
      # autoload :Associations
      autoload :Collections,  "formtastic-bootstrap/inputs/base/collections"
      autoload :Choices,      "formtastic-bootstrap/inputs/base/choices"
      # autoload :Database
      # autoload :Errors
      # autoload :Fileish
      # autoload :Hints
      # autoload :Html
      # autoload :Labelling
      # autoload :Naming
      autoload :Numeric,      "formtastic-bootstrap/inputs/base/numeric"
      # autoload :Options
      autoload :Placeholder,  "formtastic-bootstrap/inputs/base/placeholder"
      autoload :Stringish,    "formtastic-bootstrap/inputs/base/stringish"
      autoload :Timeish,      "formtastic-bootstrap/inputs/base/timeish"
      # autoload :Validations
      autoload :Wrapping,     "formtastic-bootstrap/inputs/base/wrapping"

      include Html
      # include Options
      # include Database
      # include Database
      include Errors
      include Hints
      # include Naming
      # include Validations
      # include Fileish
      # include Associations
      include Labelling
      include Wrapping

      # Ensure the full Formtastic input_html_options chain executes
      def input_html_options
        begin
          super
        rescue NotImplementedError => e
          # If super fails, return a default empty hash
          # This provides a fallback for modules that don't have a parent implementation
          {}
        end
      end

    end
  end
end
