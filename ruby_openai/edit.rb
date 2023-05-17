module RubyOpenAI
  class Edit
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end
  
    def get_response(required_params, options = {})
      response = client.edits(
        parameters: add_parameters(required_params, options)
      ).dig("choices", 0, "text")

      response
    end

    private

    def add_parameters(required_params, options)
      parameters = {
        model: self.model,
        input: required_params[:input],
        instruction: required_params[:instruction]
      }
    end
  end
end