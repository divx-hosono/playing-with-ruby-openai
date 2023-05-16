
module RubyOpenAI
  class ImageEdit
    attr_reader :client, :model

    def initialize(client, model)
      client = client
      model = model
    end
  
    def get_response(required_params, options = {})
      response = client.images.generate(
        parameters: add_parameters(required_params, options)
      )
      response.dig("data", 0, "url")
    end

    private

    def add_parameters(required_params, options)
      parameters = {
        prompt: required_params[:prompt],
      }
      if options[:size].present?
        parameters[:size] = options[:size]
      end
    end
  end
end