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

    def generate(phrase, lookup_interval_secs: 30)
      target_words = phrase.split(/\s+/)
      rhymed_words = target_words.map do |word|
        word.gsub!(/[^A-Za-z]/, '')
        next if word.empty?

        rhymes = build_rhymes(word)
        sleep(lookup_interval_secs)
        rhymes.sample || word
      end

      rhymed_words.join(' ')
    end

    private

    def build_rhymes(word)
      OpenAiClient.rhymes(word)
    end
  end
end
