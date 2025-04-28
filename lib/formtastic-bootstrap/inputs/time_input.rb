module FormtasticBootstrap
  module Inputs
    # NOTE: This input type is deprecated in Formtastic
    class TimeInput
      include Base
      include Base::Stringish

      def to_html
        ActiveSupport::Deprecation.new.warn("TimeInput (:as => :time) has been renamed to TimeSelectInput (:as => :time_select) and will be removed or changed in the next version of Formtastic, please update your forms.")
        
        # Create a modified copy of options with the correct :as value to ensure proper CSS classes
        modified_options = options.merge(as: :time, wrapper_html: { class: 'time' })
        
        # Use the TimeSelectInput with our modified options
        input = FormtasticBootstrap::Inputs::TimeSelectInput.new(builder, template, object, object_name, method, modified_options)
        input.to_html
      end
    end
  end
end