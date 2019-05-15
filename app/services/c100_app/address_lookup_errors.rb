module C100App
  class AddressLookupErrors < Hash
    def add(key, value)
      self[key] ||= []
      fetch(key) << value
      fetch(key).uniq!
    end

    def each
      each_key do |field|
        fetch(field).each { |message| yield field, message }
      end
    end

    def full_messages
      map { |attribute, message| full_message(attribute, message) }
    end

    private

    def full_message(attribute, message)
      attr_name = attribute.capitalize
      format('%<attr_name>s %<message>s', attr_name: attr_name, message: message)
    end
  end
end
