module FormtasticBootstrap
  module Inputs
    class StringInput
      include Base
      include Base::Stringish
      # StringInput in Formtastic 5.0 also includes Base::Placeholder
      include Base::Placeholder # Required for compatibility with Formtastic 5.0
    end
  end
end