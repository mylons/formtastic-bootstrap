module FormtasticBootstrap
  module Inputs
    class DatetimeSelectInput
      include Base
      include Base::DatetimePickerish
      # Formtastic 5.0 DatetimeSelectInput includes Base::Timeish

    end
  end
end