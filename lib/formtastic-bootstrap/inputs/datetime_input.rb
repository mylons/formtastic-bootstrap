module FormtasticBootstrap
  module Inputs
    # NOTE: This input type is deprecated in Formtastic
    class DatetimeInput
      include Base
      include Base::Stringish

      def to_html
        ::ActiveSupport::Deprecation.warn("DatetimeInput (:as => :datetime) has been renamed to DatetimeSelectInput (:as => :datetime_select) and will be removed or changed in the next version of Formtastic, please update your forms.", caller(2))
        FormtasticBootstrap::Inputs::DatetimePickerInput.new(builder, template, object, object_name, method, options).to_html
      end

    end
  end
end