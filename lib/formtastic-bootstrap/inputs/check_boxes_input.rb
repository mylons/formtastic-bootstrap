module FormtasticBootstrap
  module Inputs
    class CheckBoxesInput
      include Base
      include Base::Choices
      include Base::Collections

      # TODO Make sure help blocks work correctly.

      def to_html
        # Generate all content within bootstrap_wrapping
        bootstrap_wrapping do
          hidden_field_for_all <<
          collection.map { |choice|
            choice_html(choice)
          }.join("\n").html_safe
        end
      end

      # Copied from Formtastic 5.0
      def hidden_field_for_all
        if hidden_fields_for_every?
          +''
        else
          options = {}
          # Note: Removed class/id generation specific to Formtastic's fieldset>ol structure
          # options[:class] = [method.to_s.singularize, 'default'].join('_') if value_as_class?
          # options[:id] = [object_name, method, 'none'].join('_')
          template.hidden_field_tag(input_name, '', options)
        end
      end

      # Copied from Formtastic 5.0
      def hidden_fields_for_every?
        options[:hidden_fields]
      end

      def choice_html(choice)
        checkbox_wrapping do
          template.content_tag(:label, options[:hidden_fields] ?
              check_box_with_hidden_input(choice) :
              check_box_without_hidden_input(choice) <<
            choice_label(choice),
            label_html_options.merge(choice_label_html_options(choice))
          )
        end
      end

      def checkbox_wrapping(&block)
        class_name = "checkbox"
        class_name += " checkbox-inline" if options[:inline]
        template.content_tag(:div,
          template.capture(&block).html_safe,
          :class => class_name
        )
      end
      
      # Override label_method to give priority to the :label_method option
      def label_method
        options[:label_method] || super
      end
      
      # Override value_method to give priority to the :value_method option
      def value_method
        options[:value_method] || super
      end

      def choice_label(choice)
        label = if choice.is_a?(Array)
          choice.first
        elsif choice.respond_to?(:call)
          choice.call
        elsif choice.respond_to?(label_method)
          choice.send(label_method)
        else
          choice
        end
        template.content_tag(:span, ERB::Util.html_escape(label.to_s))
      end

      # Copied from Formtastic 5.0
      def check_box_with_hidden_input(choice)
        value = choice_value(choice)
        # Need association_primary_key, extra_html_options, disabled?, unchecked_value
        builder.check_box(
          association_primary_key || method,
          extra_html_options(choice).merge(:id => choice_input_dom_id(choice), :name => input_name, :disabled => disabled?(value), :required => false),
          value,
          unchecked_value
        )
      end

      # Copied from Formtastic 5.0
      def check_box_without_hidden_input(choice)
        value = choice_value(choice)
        # Need input_name, checked?, extra_html_options, disabled?
        template.check_box_tag(
          input_name,
          value,
          checked?(value),
          extra_html_options(choice).merge(:id => choice_input_dom_id(choice), :disabled => disabled?(value), :required => false)
        )
      end

      # Need helper methods called by the checkbox methods above
      # Copied from Formtastic 5.0
      def extra_html_options(choice)
        input_html_options.merge(custom_choice_html_options(choice))
      end

      # Copied from Formtastic 5.0
      def checked?(value)
        selected_values.include?(value)
      end

      # Copied from Formtastic 5.0
      def disabled?(value)
        disabled_values.include?(value)
      end

      # Copied from Formtastic 5.0
      def selected_values
        @selected_values ||= make_selected_values
      end

      # Copied from Formtastic 5.0
      def disabled_values
        vals = options[:disabled] || []
        vals = [vals] unless vals.is_a?(Array)
        vals
      end

      # Copied from Formtastic 5.0
      def unchecked_value
        options[:unchecked_value] || ''
      end

      # Copied from Formtastic 5.0
      def input_name
        if builder.options.key?(:index)
          "#{object_name}[#{builder.options[:index]}][#{association_primary_key || method}][]"
        else
          "#{object_name}[#{association_primary_key || method}][]"
        end
      end
      
      # Copied from Formtastic 5.0 (needed by selected_values)
      # Using the more accurate logic from Formtastic 5.0 source
      def make_selected_values
        if object.respond_to?(method)
          selected_items = object.send(method)
          selected_items = [*selected_items].compact.flatten

          selected_items.map do |selected_item|
            # Use value_method (from Base::Collections) to get the ID or configured value
            selected_item_id = selected_item.id if selected_item.respond_to? :id
            send_or_call_or_object(value_method, selected_item) || selected_item_id
          end.compact
        else
          []
        end
      end
      
      def reflection
        @reflection ||= builder.reflection_for(method)
      end

      # Add the belongs_to_association? method to properly detect association type
      def belongs_to_association?
        reflection && reflection.macro == :belongs_to
      end
      
      # Override choice_input_dom_id to correctly handle belongs_to associations
      def choice_input_dom_id(choice)
        attr_name = if belongs_to_association?
          "#{method}_id"
        else 
          association_primary_key || method
        end
        
        [
          builder.dom_id_namespace,
          sanitized_object_name,
          builder.options[:index],
          attr_name,
          choice_html_safe_value(choice)
        ].compact.reject { |i| i.blank? }.join("_")
      end
      
      # Ensure we have a sanitized_object_name method for the choice_input_dom_id
      def sanitized_object_name
        object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
      end
    end
  end
end
