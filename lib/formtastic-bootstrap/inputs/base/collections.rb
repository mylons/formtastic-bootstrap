module FormtasticBootstrap
  module Inputs
    module Base
      module Collections
        include Formtastic::Inputs::Base::Collections
        
        # Override collection_from_options to handle symbol collections and support value_method/label_method
        def collection_from_options
          items = options[:collection]
          collection = case items
          when Symbol
            if object.class.respond_to?(items)
              object.class.send(items)
            else
              raise "Cannot find collection #{items} on #{object.class}"
            end
          when Hash
            items.to_a
          when Range
            items.to_a.collect{ |c| [c.to_s, c] }
          else
            items
          end
          
          # Apply the value_method if specified
          if options[:value_method].present? && collection
            # Transform the collection to respect value_method and label_method
            transform_collection_with_methods(collection)
          else
            collection
          end
        end
        
        # Transform a collection to use label_method and value_method
        def transform_collection_with_methods(collection)
          return collection unless collection
          
          collection.map do |item|
            if item.is_a?(Array)
              # Collection is already an array, preserve it
              item
            elsif item.respond_to?(options[:value_method])
              # Apply value_method to the item
              label = if options[:label_method].present? && item.respond_to?(options[:label_method])
                item.send(options[:label_method])
              else
                item.to_s
              end
              [label, item.send(options[:value_method])]
            else
              # Fall back to item as both label and value
              [item.to_s, item]
            end
          end
        end
      end
    end
  end
end