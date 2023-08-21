# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    win = "Congratulations! #{@word} is a valid English word!"
    @result = if included?(@word.upcase, @letters)
                english_word?(@word) ? win : "Sorry but #{@word} does not seem to be a valid English word..."
              else
                "Sorry but #{@word} can't be built out of #{@letters}"
              end
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    att_serialized = URI.parse(url).read
    att = JSON.parse(att_serialized)
    att['found']
  end
end
