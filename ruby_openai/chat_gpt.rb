module RubyOpenAI
  class ChatGPT
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end
  
    def get_response(required_params, options = { temperature: 0.7 })
      required_params[:messages] = optimization_prompt(required_params[:messages])
      response = client.chat(
        parameters: add_parameters(required_params, options)
      )
      response.dig("choices", 0, "message", "content")
    end

    private

    def optimization_prompt
      # TODO: Add optimization prompt
    end

    def add_parameters(required_params, options)
      parameters = {
        model: self.model,
        messages: required_params[:messages],
        temperature: options[:temperature]
      }
    end
  end
end
