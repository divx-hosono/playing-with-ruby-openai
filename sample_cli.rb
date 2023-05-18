require 'thor'
require_relative './config/openai.rb'
Dir[File.expand_path("../ruby_openai", __FILE__) << "/*.rb"].each do |file|
  require file
end

class SampleCLI < Thor
  desc "chat", "ChatGPT API"
  def chat
    puts "Please input your message."
    chat_gpt = RubyOpenAI::ChatGPT.new(client, model_version)
    response = chat_gpt.get_response(messages: [{ role: "user", content: gets_chomp}])
    puts response
    while retry? do
      puts "Please input your message."
      input = gets_chomp
      response = chat_gpt.get_response(messages: [{ role: "user", content: gets_chomp}])
      puts response
    end
  end

  desc "completion", "Completion API"
  def completion
    puts "Please input your message."
    completion = RubyOpenAI::Completion.new(client, model_version("text-davinci-001"))
    response = completion.get_response(prompt: gets_chomp)
    while retry? do
      puts "Please input your message."
      input = gets_chomp
      response = completion.get_response(prompt: input)
      puts response
    end
  end

  desc "edit", "Edit API"
  def edit
    puts "Please input your message."
    edit = RubyOpenAI::Edit.new(client, model_version("text-davinci-edit-001"))
    input = gets_chomp
    puts "Please input your instruction."
    instruction = gets_chomp
    response = edit.get_response(input: input, instruction: instruction)
    puts response
  end

  desc "embedding", "Embedding API"
  def embedding
    puts "Please input your message."
    embedding = RubyOpenAI::Embedding.new(client, model_version("text-embedding-ada-002"))
    response = embedding.get_response(input: gets_chomp)
    puts response
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
    puts "plese select the image processing you wish to perform"
    puts "1: Generation"
    puts "2: Edit"
    puts "3: Variations"
    input_processing = STDIN.gets.chomp
    
    case input_processing
    when "1"
      puts "Please input image you wish to generate."
      input = STDIN.gets.chomp
      client = OpenAI::Client.new
      image = RubyOpenAI::Image.new(client, model_version("babbage-similarity"))
      response = image.generate(prompt: input)
      puts response
    when "2"
      puts "Please input image you wish to edit."
      input_prompt = STDIN.gets.chomp
      puts "Please input image file."
      input_image_file = STDIN.gets.chompg
      puts "Please input mask file path, if any."
      input_mask_file = STDIN.gets.chomp
      client = OpenAI::Client.new
      image = RubyOpenAI::Image.new(client, model_version("babbage-similarity"))
      response = image.edit(prompt: input_prompt, image: input_image_file, mask: input_mask_file)
      puts response
    when "3"
      puts "Please input image file."
      input_image_file = STDIN.gets.chomp
      puts "Please input the number of images you wish to generate."
      input_number = STDIN.gets.chomp.to_i
      client = OpenAI::Client.new
      image = RubyOpenAI::Image.new(client, model_version("babbage-similarity"))
      response = image.variations(image: input_image_file, n: input_number)
      puts response
    else
      puts "Please input 1, 2 or 3."
    end
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

  def gets_chomp
    STDIN.gets.chomp
  end

  def retry?
    puts "Would you like to try again? (y/n)"
    case gets_chomp
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

puts "Welcome to Sample CLI."
SampleCLI.start(ARGV)
puts "Thank you for using our service."