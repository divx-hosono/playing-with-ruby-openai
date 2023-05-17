module RubyOpenAI
  class File
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end
  
    def get_response(required_params, options = {})
      response = client.files.upload(
        parameters: add_parameters(required_params, options)
      )
      # TODO: 公式の形と異なるので確認する（公式：JSON.parse(response.body)["id"]）
      file_id = response["id"]
      file_id
    end

    private

    def add_parameters(required_params, options)
      parameters = {
        file: required_params[:file],
        purpose: required_params[:purpose]
      }
    end
  end
end