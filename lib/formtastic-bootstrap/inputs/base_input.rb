module FormtasticBootstrap
  module Inputs
    class BaseInput < Formtastic::Inputs::Base
      include FormtasticBootstrap::Inputs::Base
    end
  end
end 