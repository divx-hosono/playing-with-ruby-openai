
module RubyOpenAI
  class Image
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end
  
    def generate(required_params, options = {})
      response = client.images.generate(
        parameters: add_parameters(required_params, options)
      )
      response.dig("data", 0, "url")
    end

    def edit(required_params, options = {})
      response = client.images.edit(
        parameters: add_parameters(required_params, options)
      )
      response.dig("data", 0, "url")
    end

    def variations(required_params, options = {})
      response = client.images.variations(
        parameters: add_parameters(required_params, options)
      )
      responses = []
      required_params[:n].times do |i|
        responses << response.dig("data", i, "url")
      end
      responses
    end

    private

    def add_parameters(required_params, options)
      parameters = {}
      parameters[:prompt] = required_params[:prompt] if required_params[:prompt]
      parameters[:image] = required_params[:image] if required_params[:image]
      parameters[:mask] = required_params[:mask] if required_params[:mask]
      parameters[:n] = required_params[:n] if required_params[:n]
      parameters
    end
  end
end