module RubyOpenAI
  class Moderation
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end
  
    def get_response(required_params, options = {})
      response = client.moderations(
        parameters: add_parameters(required_params, options)
      )
      response.dig("results", 0, "category_scores", "hate")
    end

    private

    def add_parameters(required_params, options)
      parameters = {
        input: required_params[:input],
      }
    end
  end
end