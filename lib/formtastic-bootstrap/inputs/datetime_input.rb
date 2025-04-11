module FormtasticBootstrap
  module Inputs
    # NOTE: This input type is deprecated in Formtastic
    class DatetimeInput
      include Base
      include Base::Stringish

      def to_html
        ActiveSupport::Deprecation.new.warn("DatetimeInput (:as => :datetime) has been renamed to DatetimeSelectInput (:as => :datetime_select) and will be removed or changed in the next version of Formtastic, please update your forms.")
        
        # Create a modified copy of options with the correct :as value to ensure proper CSS classes
        modified_options = options.merge(as: :datetime, wrapper_html: { class: 'datetime' })
        
        # Use the DatetimePickerInput with our modified options
        input = FormtasticBootstrap::Inputs::DatetimePickerInput.new(builder, template, object, object_name, method, modified_options)
        input.to_html
      end
    end
  end
end