module FormtasticBootstrap
  module Inputs
    # NOTE: This input type is deprecated in Formtastic
    class TimeInput
      include Base
      include Base::Stringish

      def to_html
        ::ActiveSupport::Deprecation.warn("TimeInput (:as => :time) has been renamed to TimeSelectInput (:as => :time_select) and will be removed or changed in the next version of Formtastic, please update your forms.", caller(2))
        FormtasticBootstrap::Inputs::TimeSelectInput.new(builder, template, object, object_name, method, options).to_html
      end

    end
  end
end