# frozen_string_literal: true

module AuntieEm
  class OpenAiClient
    @client ||= ::OpenAI::Client.new
    @prompt = <<-PROMPT
      What words rhyme with the following: %s?
      Please reply with JSON where the keys are the words
      I gave you and the values are their rhymes in an array.
      Limit each array to no more than 10 rhymes.
    PROMPT

    def self.rhymes(words)
      response = @client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [
            {
              role: 'user',
              content: format(@prompt, words.join(','))
            }
          ]
        }
      )

      msg_content = response['choices']&.first&.dig('message', 'content')
      JSON.parse(msg_content || {})
    end
  end
end
