module FormtasticBootstrap
  module Inputs
    # NOTE: This input type is deprecated in Formtastic
    class DateInput
      include Base
      include Base::Stringish

      def to_html
        ActiveSupport::Deprecation.new.warn("DateInput (:as => :date) has been renamed to DateSelectInput (:as => :date_select) and will be removed or changed in the next version of Formtastic, please update your forms.")
        
        # Create a modified copy of options with the correct :as value to ensure proper CSS classes
        modified_options = options.merge(as: :date, wrapper_html: { class: 'date' })
        
        # Use the DatePickerInput with our modified options
        input = FormtasticBootstrap::Inputs::DatePickerInput.new(builder, template, object, object_name, method, modified_options)
        input.to_html
      end
    end
  end
end