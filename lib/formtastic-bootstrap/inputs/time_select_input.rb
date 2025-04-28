module FormtasticBootstrap
  module Inputs
    class TimeSelectInput < Formtastic::Inputs::TimeSelectInput
      include Base
      include Base::Stringish
      include Base::DatetimePickerish
      # Formtastic 5.0 TimeSelectInput includes Base::Timeish

      FRAGMENT_CLASSES = {
        :hour    => "col-xs-4",
        :minute  => "col-xs-4",
        :second  => "col-xs-4"
      }

      def to_html
        bootstrap_wrapping do
          template.content_tag(:span, :class => 'form-wrapper') do
            fragments_wrapping do
              (hidden_fragments + 
              fragments.map do |fragment|
                fragment_html(fragment)
              end.join.html_safe)
            end
          end
        end
      end

      def fragments_wrapping(&block)
        yield
      end

      def hidden_fragments
        # Generate hidden fields when :ignore_date is false or we're in a nested form (fields_for with index)
        if options[:ignore_date] == false || builder.options.key?(:index)
          hidden_time_fragments.map do |fragment|
            template.hidden_field_tag(hidden_field_name(fragment), fragment_value(fragment), :id => fragment_id(fragment), :disabled => input_html_options[:disabled])
          end.join.html_safe
        else
          "".html_safe
        end
      end

      def hidden_time_fragments
        # Include date fragments for hidden fields when :ignore_date is false or using fields_for with index
        if options[:ignore_date] == false || builder.options.key?(:index)
          [:year, :month, :day]
        else
          []
        end
      end

      def fragments
        # Only time fragments for visible fields
        if options[:include_seconds]
          [:hour, :minute, :second]
        else
          [:hour, :minute]
        end
      end

      def fragment_html(fragment)
        template.content_tag(:span, :class => fragment_class(fragment)) do
          template.select_tag(
            "#{fragment_prefix}[#{fragment_name(fragment)}]",
            template.options_for_select(fragment_options(fragment), fragment_value(fragment)),
            fragment_html_options(fragment)
          )
        end
      end

      def fragment_class(fragment)
        FRAGMENT_CLASSES[fragment] || "col-xs-4"
      end

      def fragment_html_options(fragment)
        opts = input_html_options.merge(:id => fragment_id(fragment), :class => "form-control")
        opts[:required] = required_attribute? if required_attribute?
        opts
      end

      def fragment_value(fragment)
        if value && value.respond_to?(fragment)
          value.send(fragment)
        elsif fragment == :year
          Time.now.year
        elsif fragment == :month || fragment == :day
          # Default to 1 for month and day if not provided
          "1"
        else
          "00"
        end
      end

      def fragment_name(fragment)
        "#{method}(#{position(fragment)}i)"
      end

      def hidden_field_name(fragment)
        if builder.options.key?(:index)
          "#{object_name}[#{builder.options[:index]}][#{fragment_name(fragment)}]"
        else
          "#{object_name}[#{fragment_name(fragment)}]"
        end
      end

      def fragment_id(fragment)
        [
          builder.dom_id_namespace,
          sanitized_object_name,
          dom_index,
          method,
          "#{position(fragment)}i"
        ].compact.join('_')
      end

      def dom_index
        if builder.options.has_key?(:index)
          builder.options[:index]
        elsif !builder.auto_index.blank?
          builder.auto_index
        else
          nil
        end
      end

      def position(fragment)
        positions[fragment]
      end

      def positions
        { :year => 1, :month => 2, :day => 3, :hour => 4, :minute => 5, :second => 6 }
      end

      def fragment_prefix
        if builder.options.key?(:index)
          object_name + "[#{builder.options[:index]}]"
        else
          object_name
        end
      end

      def fragment_options(fragment)
        case fragment
        when :hour
          0..23
        when :minute, :second
          0..59
        end.map { |i| [i, i] }
      end

      def sanitized_object_name
        object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
      end

      def wrapper_html_options
        super.tap do |options|
          options[:id] = wrapper_dom_id
        end
      end

      def wrapper_dom_id
        [
          builder.dom_id_namespace,
          sanitized_object_name,
          dom_index,
          method,
          'input'
        ].compact.join('_')
      end

      def value
        return options[:selected] if options.key?(:selected)
        object.send(method) if object && object.respond_to?(method)
      end
      
      def required_attribute?
        options[:required] && builder.all_fields_required_by_default
      end

      def input_html_options
        {
          :class => ['form-control', 'input'],
          :required => required_attribute?
        }.merge(options[:input_html] || {})
      end
    end
  end
end
