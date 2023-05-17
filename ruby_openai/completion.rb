module RubyOpenAI
  class Completion
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end
  
    def get_response(required_params, options = { max_tokens: 5 })
      response = client.completions(
        parameters: add_parameters(required_params, options)
      )
      puts response["choices"].map { |c| c["text"] }
    end

    private

    def add_parameters(required_params, options)
      parameters ={
        model: self.model,
        prompt: required_params[:prompt],
        max_tokens: options[:max_tokens]
      }
    end
  end  
end