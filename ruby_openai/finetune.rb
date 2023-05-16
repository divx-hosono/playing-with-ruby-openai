module RubyOpenAI
  class FineTune
    attr_reader :client, :model

    def initialize(client, model)
      client = client
      model = model
    end
  
    def get_response(required_params, options = {})
    end

    private

    def add_parameters(required_params, options)
    end
  end
end