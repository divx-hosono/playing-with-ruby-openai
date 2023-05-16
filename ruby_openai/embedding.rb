
module RubyOpenAI
  class Embedding
    attr_reader :client, :model

    def initialize(client)
      client = client
    end
  
    def get_response(required_params, options = {})
      response = client.embeddings(
        parameters: add_parameters(required_params, options)
      )
      response
    end

    private

    def add_parameters(required_params, options)
      parameters = {
        model: self.model,
        input: required_params[:input]
      }
    end
  end
end