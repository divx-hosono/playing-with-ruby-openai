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
    puts "Please input your message."
    chat_gpt = RubyOpenAI::ChatGPT.new(client, model_version)
    response = chat_gpt.get_response(messages: [{ role: "user", content: input_message}])
    puts response
    while retry? do
      puts "Please input your message."
      input = input_message
      response = chat_gpt.get_response(messages: [{ role: "user", content: input_message}])
      puts response
    end
    thanks_message
  end

  desc "completion", "Completion API"
  def completion
    puts "Please input your message."
    completion = RubyOpenAI::Completion.new(client, model_version("text-davinci-001"))
    response = completion.get_response(prompt: input_message)
    while retry? do
      puts "Please input your message."
      input = input_message
      response = completion.get_response(prompt: input)
      puts response
    end
    thanks_message
  end

  desc "edit", "Edit API"
  def edit
    puts "Please input your message."
    edit = RubyOpenAI::Edit.new(client, model_version("text-davinci-edit-001"))
    input = input_message
    puts "Please input your instruction."
    instruction = input_message
    response = edit.get_response(input: input, instruction: instruction)
    puts response
    thanks_message
  end

  desc "embedding", "Embedding API"
  def embedding
    puts "Please input your message."
    embedding = RubyOpenAI::Embedding.new(client, model_version("text-embedding-ada-002"))
    input = input_message
    response = embedding.get_response(input: input)
    puts response
    thanks_message
  end

  desc "file", "File API"
  def file
    puts "Please input the path to the json file."
    input = STDIN.gets.chomp
    client = OpenAI::Client.new
    file = RubyOpenAI::File.new(client, model_version("ada"))
    response = file.get_response(file: input, purpose: "fine-tune")
    puts response
  end

  desc "finetune", "FineTune API"
  def finetune
    puts "Please input the path to the json file for fine tuning."
    input = STDIN.gets.chomp
    client = OpenAI::Client.new
    finetune = RubyOpenAI::FineTune.new(client, model_version("ada"))
    response = finetune.get_response(file: input, purpose: "fine-tune")
    puts response
  end

  desc "image", "Image API"
  def image
    puts "Please input image you wish to generate."
    input = STDIN.gets.chomp
    client = OpenAI::Client.new
    image = RubyOpenAI::Image.new(client, model_version("babbage-similarity"))
    response = image.get_response(prompt: input)
    puts response
  end

  desc "moderation", "Moderation API"
  def moderation
    puts "Please input your message."
    input = STDIN.gets.chomp
    # TODO: 画像サイズの入力等もできるようにする
    client = OpenAI::Client.new
    moderation = RubyOpenAI::Moderation.new(client, model_version)
    response = moderation.get_response(input: input)
    puts response
  end

  desc "transcribe", "Transcribe API"
  def transcribe
    puts "Please input audio file path."
    input = STDIN.gets.chomp
    client = OpenAI::Client.new
    transcribe = RubyOpenAI::Transcribe.new(client, model_version("whisper-1"))
    response = transcribe.get_response(file: input, extension: "rb")
    puts response
  end

  desc "translate", "Translate API"
  def translate
    puts "Please input audio file path."
    input = STDIN.gets.chomp
    client = OpenAI::Client.new
    translate = RubyOpenAI::Translate.new(client, model_version("whisper-1"))
    response = translate.get_response(file: input, extension: "rb")
    puts response
  end

  private

  def client
    OpenAI::Client.new
  end

  def model_version(model_version = "gpt-3.5-turbo")
    model_version = model_version
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