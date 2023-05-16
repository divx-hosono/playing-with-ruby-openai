module RubyOpenAI
  class ChatGPT
    attr_reader :client, :model

    def initialize(client, model)
      client = client
      model = model
    end
  
    def get_response(required_params, options = {})
      response = client.chat(
        parameters: add_parameters(required_params, options)
      )
      response
    end

    private

    def add_parameters(required_params, options)
      parameters = {
        model: self.model,
        messages: required_params[:messages]
      }
      if options[:temperature].present?
        parameters[:temperature] = options[:temperature]
      end
    end
  end
end
