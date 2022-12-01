# frozen-string-literal: true

require 'pry-byebug'

# create instance of new game
class NewGame
  attr_accessor :incorrect_guesses_left, :user_input
  attr_reader :word

  def initialize
    @incorrect_guesses_left = 10
    @word = 'corndog'
    @attempted_guesses = []
    @blank_word = nil
    play_game
  end

  #### input management ####

  # get user input
  def ask_user
    input = ''
    until input_ok?(input) == true && already_guessed?(input, @attempted_guesses) == false
      p "youve already guessed the letter #{input}." if already_guessed?(input, @attempted_guesses) == true
      p 'enter your guess: '
      input = gets.chomp
    end
    input
  end

  # check if current guess was already guessed
  # def already_guessed?(user_input, previous_guesses)
  #   previous_guesses.length.times do |i|
  #     return true if user_input == previous_guesses[i]
  #   end
  #   false
  # end

  # check input contains only uppercase or lowercase letters, and is only 1chr long
  def input_ok?(input)
    input.length == 1 && (input.count('^A-Z').zero? || input.count('^a-z').zero?)
  end

  #### blank management ####

  # create blank 'word' based on how many chars answer has
  def generate_blank(answer)
    blank_letters = ''
    answer.length.times do
      blank_letters += '_'
    end
    blank_letters
  end

  # update blank 'word' based on matches with user input'
  def update_blank(blank, answer, user_input)
    answer.length.times do |i|
      blank[i] = answer[i] if user_input == answer[i]
    end
  end

  #### round/game management ####

  # check for winning condition

  def player_won?(blank, answer)
    blank == answer
  end

  # play a single round of hangman

  def play_round(user_input)
    @attempted_guesses.push(user_input)

    @blank_word = generate_blank(@word) if @blank_word.nil?

    former_blank = @blank_word.clone

    update_blank(@blank_word, @word, user_input)

    if former_blank == @blank_word
      @incorrect_guesses_left -= 1
      p 'oops! wrong guess..'
    end

    p "you have #{@incorrect_guesses_left} guesses left."
    puts "previously tried guesses: #{@attempted_guesses}"

    p @blank_word
  end

  def play_game
    until @incorrect_guesses_left.zero?

      input = ask_user
      play_round(input)

      if player_won?(@blank_word, @word)
        p 'you win!'
        return
      end

    end
    p 'guess you lost :('
  end
end

NewGame.new
