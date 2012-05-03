require 'active_model/naming'
require 'active_support/core_ext/object/blank'
require 'faraday'

module Firebase
  class Model
    extend ActiveModel::Naming

    class << self
      # Returns the list_name used to store records in Firebase
      def list_name
        @list_name ||= ActiveModel::Naming.plural(self)
      end

      # Overrides default list name
      def list_name=(other)
        @list_name = other
      end

      # Write data
      #   User.set('name', { 'name' => 'Oscar' })
      def set(name, val)
        Firebase::Request.put("#{list_name}/#{name}", val)
      end
    end
  end
end
