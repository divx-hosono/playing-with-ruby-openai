module RubyOpenAI
  class FineTune
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end

    def get_response(required_params, options = {})
      file = RubyOpenAI::File.new(client, "ada")
      file_id = file.get_response(required_params)
      response = client.finetunes.create(
        parameters: add_parameters(file_id, options)
      )
      response
    end

    private

    def add_parameters(file_id, options)
      parameters = {
        training_file: file_id,
        model: self.model
      }
    end
  end
end