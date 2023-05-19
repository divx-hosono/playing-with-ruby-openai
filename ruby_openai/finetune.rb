module RubyOpenAI
  class FineTune
    attr_reader :client, :model

    def initialize(client, model)
      @client = client
      @model = model
    end

    def get_response(required_params, options = {})
      file = RubyOpenAI::File.new(client, "ada")
      file_id = file.get_response(required_params)["id"]
      response = client.finetunes.create(
        parameters: add_parameters(file_id, options)
      )
      response
    end

    def create(file_id)
      response = client.finetunes.create(
        parameters: {
        training_file: file_id,
        model: "ada"
      })
      fine_tune_id = response["id"]
    end

    def cancel(fine_tune_id)
      client.finetunes.cancel(id: fine_tune_id)
    end

    def list
      client.finetunes.list
    end

    def retrieve(fine_tune_id)
      client.finetunes.retrieve(id: fine_tune_id)
      fine_tuned_model = response["fine_tuned_model"]
    end

    def completions(required_params)
      response = client.completions(
        parameters: {
        model: required_params[:fine_tuned_model],
        prompt: required_params[:prompt]
        }
      )
      response
    end

    def delete(fine_tuned_model)
      client.finetunes.delete(fine_tuned_model: fine_tuned_model)
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