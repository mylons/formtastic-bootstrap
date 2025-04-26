module FormtasticBootstrap
  module Inputs
    module Base
      module Collections
        include Formtastic::Inputs::Base::Collections
        
        # Override collection_from_options to handle symbol collections
        def collection_from_options
          items = options[:collection]
          case items
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
        end
      end
    end
  end
end