require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
    @time_start = Time.now
  end

  def score
    @time_end = Time.now
    @start_t = params[:start_time].to_datetime
    @game_results = run_game(params[:word], params[:grid], @start_t, @time_end)
  end

  private

  # generates a grid of letters
  def generate_grid
    (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  # checks if the word is english with the api given
  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  # checks if it is possible that the word is in the grid
  def word_in_the_grid?(attempt, grid)
    attempt_array = attempt.upcase.split('')
    attempt_array.each do |letter|
      return false if attempt_array.count(letter) > grid.count(letter)
      return false unless grid.include? letter
    end
    true
  end

  # Basiccly runs the game and uses the english_word?
  # and the check_ grid
  # Than put everything in a result hash and return that hash
  def run_game(attempt, grid, start_time, end_time)
    result = { time: (end_time - start_time), score: 0 }

    if word_in_the_grid?(attempt, grid) != true
      result[:message] = 'Word is not in the grid!'
    elsif english_word?(attempt) != true
      result[:message] = 'not an english word'
    else
      result[:score] = 100 - (end_time - start_time) + attempt.length
      result[:message] = 'well done'
    end
    result
  end
end
