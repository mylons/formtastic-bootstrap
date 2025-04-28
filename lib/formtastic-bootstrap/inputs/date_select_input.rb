module FormtasticBootstrap
  module Inputs
    class DateSelectInput < Formtastic::Inputs::DateSelectInput
      include Base
      include Base::Stringish

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
        hidden_date_fragments.map do |fragment|
          template.hidden_field_tag(hidden_field_name(fragment), fragment_value(fragment), :id => fragment_id(fragment), :disabled => input_html_options[:disabled])
        end.join.html_safe
      end

      def hidden_date_fragments
        default_date_fragments - fragments
      end

      def default_date_fragments
        [:year, :month, :day]
      end

      def fragments
        options[:order] || i18n_date_fragments || default_date_fragments
      end

      def i18n_date_fragments
        order = ::I18n.t(:order, :scope => [:date])
        if order.is_a?(Array)
          order.map &:to_sym
        else
          nil
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
        case fragment
        when :year then "col-xs-4"
        when :month then "col-xs-5"
        when :day then "col-xs-3"
        end
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
        else
          "1"
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
        when :year
          (options[:start_year] || Date.today.year - 5)..(options[:end_year] || Date.today.year + 5)
        when :month
          1..12
        when :day
          1..31
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
