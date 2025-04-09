module FormtasticBootstrap
  module Inputs
    class TimeSelectInput
      include Base
      include Base::DatetimePickerish
      # Formtastic 5.0 TimeSelectInput includes Base::Timeish

      FRAGMENT_CLASSES = {
        :hour    => "col-xs-4",
        :minute  => "col-xs-4",
        :second  => "col-xs-4"
      }

    end
  end
end
