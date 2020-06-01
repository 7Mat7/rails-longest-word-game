require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    def random_letter(number)
      charset = Array('A'..'Z')
      Array.new(number) { charset.sample }
    end
    @random = random_letter(10)
  end

  def score
    @answer = params[:answer]
    @answer_array = @answer.split('').sort
    @check = params[:random].downcase.split(' ').sort

    def included?(guess, grid)
      guess.all? { |letter| guess.count(letter) <= grid.count(letter) }
    end

    @final = included?(@answer_array, @check)

    request_uri = 'https://wagon-dictionary.herokuapp.com/'
    request_query = @answer
    url = "#{request_uri}#{request_query}"
    buffer = open(url).read
    @result = JSON.parse(buffer)

      if @final == false
        @win_lose = "Sorry but TEST cannot be built from #{@check}"
      elsif @result[:found] == false
        @win_lose = "Sorry but #{@answer} does not seem to be an English word"
      else
        @win_lose = "Congratulations! #{@answer} is a valid word!"
      end
  end
end
