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
        # モデルは、翻訳モデルのみ指定可能らしい
        model: "whisper-1",
        # トップレベルの指定をしないと、RubyOpenAI::Fileクラスにopenメソッドがない?と言われる
        file: ::File.open(required_params[:file], required_params[:extension])
      }
    end
  end
end