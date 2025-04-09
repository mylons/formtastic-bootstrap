require "formtastic"
require "formtastic/version"
# Attempt to force load Formtastic components before proceeding
require "formtastic/form_builder"

require "formtastic-bootstrap/engine" if defined?(::Rails) # For tests
# Restore direct requires
require "formtastic-bootstrap/helpers"
require "formtastic-bootstrap/inputs"
require "formtastic-bootstrap/actions"
require "formtastic-bootstrap/form_builder"
require "action_view/helpers/text_field_date_helper"

module FormtasticBootstrap
  # Remove autoload configuration - revert to direct requires
  # extend ActiveSupport::Autoload
  # autoload :FormBuilder, "formtastic-bootstrap/form_builder"
  # autoload :Helpers,     "formtastic-bootstrap/helpers"
  # autoload :Inputs,      "formtastic-bootstrap/inputs"
  # autoload :Actions,     "formtastic-bootstrap/actions"

  # ... Keep any other pre-existing code within the module ...
end
