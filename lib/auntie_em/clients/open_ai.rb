module AuntieEm
  class OpenAiClient
    @client ||= ::OpenAI::Client.new
    @prompt = <<-PROMPT
      What words rhyme with %s?
      Please reply only with a list of comma-separated words
      and limit your answer to 10 words.
    PROMPT

    def self.rhymes(word)
      response = @client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [
            {
              role: 'user',
              content: format(@prompt, word)
            }
          ]
        }
      )

      msg_contents = response['choices'].map do |choice|
        choice.dig('message', 'content')
      end

      msg_contents.compact.join(', ').split(/,\s+/)
    end
  end
end
