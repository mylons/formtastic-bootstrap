module FormtasticBootstrap
  module Inputs
    # NOTE: This input type is deprecated in Formtastic
    class DateInput
      include Base
      include Base::Stringish

      def to_html
        #::ActiveSupport::Deprecation.warn("DateInput (:as => :date) has been renamed to DateSelectInput (:as => :date_select) and will be removed or changed in the next version of Formtastic, please update your forms.", caller(2))
        FormtasticBootstrap::Inputs::DatePickerInput.new(builder, template, object, object_name, method, options).to_html
      end

    end
  end
end