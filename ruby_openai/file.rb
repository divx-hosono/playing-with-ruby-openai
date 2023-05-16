module RubyOpenAI
  class File
    attr_reader :client, :model

    def initialize(client, model)
      client = client
      model = model
    end
  
    def get_response(required_params, options = {})
    end

    private

    def add_parameters(model, messages, options = {})
    end
  end
end