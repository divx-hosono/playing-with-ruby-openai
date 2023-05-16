module RubyOpenAI
  class ChatGPT
    def initialize
    end
  
    def get_response(client)
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [{ role: "user", content: "Hello!"}], # Required.
          temperature: 0.7,
        }
      )
      response
    end
  end
end
