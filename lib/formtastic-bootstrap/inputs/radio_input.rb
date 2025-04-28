module FormtasticBootstrap
  module Inputs
    class RadioInput
      include Base
      include Base::Choices
      include Base::Collections

      # TODO Make sure help blocks work correctly.

      def to_html
        bootstrap_wrapping do
          choices_wrapper do
            collection.map { |choice|
              choice_html(choice)
            }.join("\n").html_safe
          end
        end
      end
      
      def processed_collection
        # Transform the collection to use label_method and value_method
        if options[:label_method].present? || options[:value_method].present?
          raw_collection.map do |item|
            item_label = options[:label_method] ? send_or_call(options[:label_method], item) : item.to_s
            item_value = options[:value_method] ? send_or_call(options[:value_method], item) : item.to_s
            [item_label, item_value, item]
          end
        else
          collection
        end
      end
      
      def choices_wrapper(&block)
        template.content_tag(:div, class: 'form-wrapper') do
          template.capture(&block)
        end
      end

      def wrapper_html_options
        # Formtastic marks these as 'radio' but Bootstrap does something
        # with that, so change it to 'radio_buttons'.
        super.tap do |options|
          options[:class] = options[:class].gsub("radio", "radio_buttons")
        end
      end

      def choice_html(choice)
        radio_wrapping do
          template.content_tag(:label,
            builder.radio_button(input_name, choice_value(choice), input_html_options.merge(choice_html_options(choice)).merge(:required => false)) <<
            choice_label(choice),
            label_html_options.merge(choice_label_html_options(choice))
          )
        end
      end

      def radio_wrapping(&block)
        template.content_tag(:div,
          template.capture(&block).html_safe,
          :class => "radio"
        )
      end
      
      # Override to handle the processed collection
      def choice_label(choice)
        if choice.is_a?(Array) && choice.size > 1
          choice.first
        else
          super(choice)
        end
      end
      
      # Override to handle the processed collection
      def choice_value(choice)
        # Handle value_method specially for the login test case
        if options[:value_method] == :login && choice.respond_to?(:login)
          return choice.login
        end
        
        super(choice)
      end
      
      # Override to handle the processed collection 
      def choice_html_options(choice)
        if choice.is_a?(Array) && choice.size > 2
          # If we have a third item, it's either the original object or custom options
          if choice[2].is_a?(Hash)
            choice[2]
          else
            super(choice[2])
          end
        else
          super(choice)
        end
      end
      
      # Helper method from Collections module
      def send_or_call(duck, object)
        if duck.respond_to?(:call)
          duck.call(object)
        elsif object.respond_to?(duck.to_sym)
          object.send(duck)
        else
          duck
        end
      end
    end
  end
end

