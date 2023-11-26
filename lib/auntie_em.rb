# frozen_string_literal: true

require 'dotenv/load'
require 'openai'

require 'auntie_em/config/open_ai'
require 'auntie_em/clients/open_ai'

module AuntieEm
  class << self
    def hello_world
      puts "We're off to see the wizard, the wonderful wizard of Matz ♪"
    end

    def generate(phrase)
      orig_tokens = phrase.split(/\s+/)
      stripped_tokens = orig_tokens.map { |t| t.gsub(/[^A-Za-z'-]/, '') }
      rhymes = build_rhymes(stripped_tokens)
      stripped_tokens.each_with_index do |token, i|
        next if token.empty?

        rhyme = rhymes.fetch(token, []).sample
        next if rhyme.nil?

        orig_tokens[i].gsub!(token, rhyme)
      end

      orig_tokens.join(' ')
    end

    private

    def build_rhymes(words)
      OpenAiClient.rhymes(words.filter { |t| !t.empty? })
    end
  end
end
