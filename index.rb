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

# 言語モデルのバージョン
MODEL_VERSION = "gpt-3.5-turbo"

# ここにユーザーインターフェイスを書く
client = OpenAI::Client.new

# CHAT GPTを使用する場合（サンプル）
chat_gpt = RubyOpenAI::ChatGPT.new(client, MODEL_VERSION)
response = chat_gpt.get_response(messages: [{ role: "user", content: "Hello!"}])

puts response