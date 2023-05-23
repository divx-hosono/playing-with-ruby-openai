module RubyOpenAI
  class Translate
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end
  
    def get_response(required_params, options = {})
      response = client.translate(
        parameters: add_parameters(required_params, options)
      )
      response["text"]
    end

    private

    def add_parameters(required_params, options)
      parameters = {
        model: self.model,
        file: ::File.open(required_params[:file], required_params[:extension])
      }
    end
  end
end