module FormtasticBootstrap
  module Inputs
    class TimeZoneInput
      include Base
      include Base::Collections

      def to_html
        bootstrap_wrapping do
          builder.time_zone_select(method, options[:priority_zones], input_options, input_html_options)
        end
      end

    end
  end
end
