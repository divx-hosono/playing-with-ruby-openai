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
  desc "chat", "ChatGPT API"
  def chat
    prompt_message
    chat_gpt = RubyOpenAI::ChatGPT.new(client, model_version)
    response = chat_gpt.get_response(messages: [{ role: "user", content: input_message}])
    puts response
  end

  desc "completion", "Completion API"
  def completion
    prompt_message
    completion = RubyOpenAI::Completion.new(client, model_version("text-davinci-001"))
    completion.get_response(prompt: input_message)
    while retry? do
      prompt_message
      input = input_message
      completion.get_response(prompt: input)
    end
    thanks_message
  end

  desc "edit", "Edit API"
  def edit

  end

  desc "transcribe", "Transcribe API"
  def transcribe
    puts "Please input audio file path."
    input = STDIN.gets.chomp
    client = OpenAI::Client.new
    transcribe = RubyOpenAI::Transcribe.new(client, model_version("whisper-1"))
    response = transcribe.get_response({file: input, extension: "rb"})
    puts response
  end

  desc "translate", "Translate API"
  def translate
    puts "Please input audio file path."
    input = STDIN.gets.chomp
    client = OpenAI::Client.new
    translate = RubyOpenAI::Translate.new(client, model_version("whisper-1"))
    response = translate.get_response({file: input, extension: "rb"})
    puts response
  end

  private

  def client
    OpenAI::Client.new
  end

  def model_version(model_version = "gpt-3.5-turbo")
    model_version = model_version
  end

  def prompt_message
    puts "Please input your message."
  end

  def thanks_message
    puts "Thank you for using our service."
  end

  def input_message
    STDIN.gets.chomp
  end

  def retry?
    puts "Would you like to try again? (y/n)"
    case input_message
    when "y"
      true
    when "n"
      false
    else
      puts "Please enter y or n."
      retry?
    end
  end
end

SampleCLI.start(ARGV)