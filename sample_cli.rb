require 'thor'
require 'matrix'

require_relative './config/openai.rb'
Dir[File.expand_path("../ruby_openai", __FILE__) << "/*.rb"].each do |file|
  require file
end

class SampleCLI < Thor
  desc "chat", "ChatGPT API"
  def chat
    messages = []
    chat_gpt = RubyOpenAI::ChatGPT.new(client, model_version)
    input = ""
    while input != "exit" do
      puts "Please input your message."
      puts "If you want to exit, please input 'exit'."
      input = gets_chomp
      return if input == "exit"
      messages.push({ role: "user", content: input })
      begin
        response = chat_gpt.get_response(messages: messages)
        puts response["content"]
      rescue
        puts "Sorry, An unexpected error has occurred."
        puts "Please try again after 20sec."
      end
    end
  end

  desc "completion", "Completion API"
  def completion
    puts "Please input your message."
    completion = RubyOpenAI::Completion.new(client, model_version("text-davinci-001"))
    input = gets_chomp
    response = completion.get_response(prompt: input)
    puts input + response.join("")
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
    embedding = RubyOpenAI::Embedding.new(client, model_version("text-embedding-ada-002"))

    puts "Please input your message."
    response_1= embedding.get_response(input: gets_chomp)
    vector1 = Vector.elements(response_1)

    puts "Please input your message to compare."
    response_2 = embedding.get_response(input: gets_chomp)
    vector2 = Vector.elements(response_2)
    
    # ベクトル同士の内積を計算（計算結果の値が1.0に近いほど類似性が高い）
    calc_result = vector2.inner_product(vector1)/(vector1.norm() * vector2.norm())
    puts calc_result
  end

  desc "file", "File API"
  options :upload => :boolean, :list => :boolean, :retrieve => :boolean, :content => :boolean, :delete => :boolean
  def file
    client = OpenAI::Client.new
    file = RubyOpenAI::File.new(client, model_version("ada"))
    if options[:upload]
      puts "Please input the path to the json file."
      response = file.get_response(file: gets_chomp, purpose: "fine-tune")
      puts response
    elsif options[:list]
      puts file.list
    elsif options[:retrieve]
      puts "Please input file id."
      puts file.retrieve(gets_chomp)
    elsif options[:content]
      puts "Please input file id."
      puts file.content(gets_chomp)
    elsif options[:delete]
      puts "Please input file id."
      puts file.delete(gets_chomp)
    end
  end

  desc "finetune", "FineTune API"
  options :upload => :boolean, :create => :boolean, :cancel => :boolean, :list => :boolean, :retrieve => :boolean, :completions => :boolean, :delete => :boolean
  def finetune
    client = OpenAI::Client.new
    finetune = RubyOpenAI::FineTune.new(client, model_version("ada"))

    case options.keys.join("")
    when "upload"
      puts "Please input the path to the json file for fine tuning."
      response = finetune.get_response(file: gets_chomp, purpose: "fine-tune")
      puts response
    when "create"
      puts "Please input file id."
      puts finetune.create(gets_chomp)
    when "cancel"
      puts "Please input fine tune id."
      puts finetune.cancel(gets_chomp)
    when "list"
      puts finetune.list
    when "retrieve"
      puts "Please input fine tune id."
      puts finetune.retrieve(gets_chomp)
    when "completions"
      puts "Please input fine tuned model."
      fine_tuned_model = gets_chomp
      puts "Please input your message."
      prompt = gets_chomp
      puts finetune.completions(fine_tuned_model: fine_tuned_model, prompt: prompt)
    when "delete"
      puts "Please input fine tuned model."
      puts finetune.delete(gets_chomp)
    end
  end

  desc "image", "Image API"
  options :generation => :boolean, :edit => :boolean, :variations => :boolean
  def image
    client = OpenAI::Client.new
    image = RubyOpenAI::Image.new(client, model_version("babbage-similarity"))

    case options.keys.join("")
    when "generation"
      puts "Please input image you wish to generate."
      response = image.generate(prompt: gets_chomp)
      puts response
    when "edit"
      puts "Please input image you wish to edit."
      input_prompt = gets_chomp
      puts "Please input image file."
      input_image_file = gets_chomp
      puts "Please input mask file."
      input_mask_file = gets_chomp
      response = image.edit(prompt: input_prompt, image: input_image_file, mask: input_mask_file)
      puts response
    when "variations"
      puts "Please input image file."
      input_image_file = gets_chomp
      puts "Please input the number of images you wish to generate."
      input_number = gets_chomp.to_i
      response = image.variations(image: input_image_file, n: input_number)
      puts response
    end
  end

  desc "moderation", "Moderation API"
  def moderation
    puts "Please input your message."
    client = OpenAI::Client.new
    moderation = RubyOpenAI::Moderation.new(client, model_version)
    response = moderation.get_response(input: gets_chomp)
    if response
      puts "This message violates policy."
    else
      puts "This message does not violate policy."
    end
  end

  desc "translate", "Translate API"
  def translate
    puts "Please input audio file path."
    client = OpenAI::Client.new
    translate = RubyOpenAI::Translate.new(client, model_version("whisper-1"))
    response = translate.get_response(file: gets_chomp, extension: "rb")
    puts response
  end

  desc "transcribe", "Transcribe API"
  def transcribe
    puts "Please input audio file path."
    client = OpenAI::Client.new
    transcribe = RubyOpenAI::Transcribe.new(client, model_version("whisper-1"))
    response = transcribe.get_response(file: gets_chomp, extension: "rb")
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
end

puts "---------------------------------"
puts "Welcome to Sample CLI."
puts "---------------------------------"
SampleCLI.start(ARGV)
puts "---------------------------------"
puts "Thank you for using our service."
puts "---------------------------------"