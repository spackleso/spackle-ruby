module Spackle
  class FileStore < BaseStore
    def initialize(path)
      @path = path
    end

    def get_customer_data(id)
      content = File.read(@path)
      data = JSON.parse(content)
      data[id]
    end

    def set_customer_data(id, customer_data)
      data = {}
      if File.exist?(@path)
        content = File.read(@path)
        data = JSON.parse(content)
      end

      data[id] = customer_data
      File.write(@path, JSON.pretty_generate(data))
    end
  end
end
