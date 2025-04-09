module FormtasticBootstrap
  module Inputs
    module Base
      module DatetimePickerish
        include Base::Placeholder
        include Formtastic::Inputs::Base::DatetimePickerish
        
        # Don't override input_html_options here - let the correct inheritance chain handle it
        # The NotImplementedError occurs because there's no valid super implementation
        # in the method resolution chain when this module is included in DatePickerInput
      end
    end
  end
end