module FormtasticBootstrap
  module Inputs
    class StringInput
      include Base
      include Base::Stringish
      # StringInput in Formtastic 5.0 also includes Base::Placeholder
      # include Base::Placeholder # Add if needed for placeholder functionality
    end
  end
end