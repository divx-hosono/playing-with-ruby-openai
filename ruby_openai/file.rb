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
      response
      # TODO: 公式の形と異なるので確認する（公式：JSON.parse(response.body)["id"]）
      # file_id = response["id"]
      # file_id
    end

    def list
      response = client.files.list
    end

    def retrieve(file_id)
      client.files.retrieve(id: file_id)
    end

    def content(file_id)
      client.files.content(id: file_id)
    end

    def delete(file_id)
      client.files.delete(id: file_id)
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