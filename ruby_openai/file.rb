module RubyOpenAI
  class File
    attr_reader :client, :model

    def initialize(client, model)
      client = client
      model = model
    end
  
    def get_response(required_params, options = {})
      response = client.files.upload(
        parameters: add_parameters(required_params, options)
      )
      file_id = JSON.parse(response.body)["id"]
      file_id
    end

    private

    def add_parameters(model, messages, options)
      parameters = {
        file: required_params[:file],
        purpose: required_params[:purpose]
      }
    end
  end
end