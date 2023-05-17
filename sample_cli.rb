require 'thor'
require_relative './config/openai.rb'
require_relative './ruby_openai/chat_gpt.rb'
require_relative './ruby_openai/completion.rb'
require_relative './ruby_openai/edit.rb'
require_relative './ruby_openai/embedding.rb'
require_relative './ruby_openai/file.rb'
require_relative './ruby_openai/finetune.rb'
require_relative './ruby_openai/image.rb'
require_relative './ruby_openai/moderation.rb'
require_relative './ruby_openai/transcribe.rb'
require_relative './ruby_openai/translate.rb'


class SampleCLI < Thor
  # 言語モデルのバージョン
  MODEL_VERSION = "gpt-3.5-turbo"
  @client = OpenAI::Client.new

  desc "chat", "ChatGPT API"
  def chat
    chat_gpt = RubyOpenAI::ChatGPT.new(@client, MODEL_VERSION)
    chat_gpt.optimization_prompt("Hello, I'm a chatbot")
    response = chat_gpt.get_response(messages: [{ role: "user", content: "Hello!"}])
    puts response
  end
end

SampleCLI.start(ARGV)