# frozen-string-literal: true

require 'pry-byebug'

module Display
  def display_round_info(blank, incorrect_guesses_left, attempted_guesses)
    puts "#{blank}"
    puts "you have #{incorrect_guesses_left} guesses left."
    puts "previously tried guesses: #{attempted_guesses}"
    puts "type \'save\' to save at any time. type \'exit\' to exit\n at anytime."
  end
end

# create instance of new game
class NewGame
  include Display
  attr_accessor :incorrect_guesses_left
  attr_reader :word

  def initialize
    @incorrect_guesses_left = 10
    @word = rand_word
    @attempted_guesses = []
    @blank_word = generate_blank(@word)
    ask_load_or_new
  end

  #### grab random word from dictionary ####

  def rand_word
    # grab dictionary file
    dictionary = File.readlines('dictionary.txt')
    # grab a random line
    dictionary[rand(dictionary.length)].strip
  end

  #### input management ####

  # get user input

  private

  def ask_load_or_new
    input = ''
    until %w[L N].include?(input)
      p "press 'L' to load a saved game.\n press 'N' to start a new game."
      input = gets.chomp
      if input == 'L'
        # load_game
      elsif input == 'N'
        play_game
      end
    end
  end

  # def load_game

  # end

  # def save_game

  # end

  def get_valid_char(input)
    until input_ok?(input) == true && already_guessed?(input, @attempted_guesses) == false
      p "youve already guessed the letter #{input}." if already_guessed?(input, @attempted_guesses) == true
      p 'enter your guess: '
      input = gets.chomp
    end
    input
  end

  # check if current guess was already guessed

  def already_guessed?(input, attempted_guesses)
    attempted_guesses.length.times do |i|
      return true if input == attempted_guesses[i]
    end
    false
  end

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

    former_blank = @blank_word.clone

    update_blank(@blank_word, @word, user_input)

    return unless former_blank == @blank_word

    @incorrect_guesses_left -= 1
    p 'oops! wrong guess..'
  end

  def play_game
    input = ''
    until @incorrect_guesses_left.zero?
      display_round_info(@blank_word, @incorrect_guesses_left, @attempted_guesses)
      input = gets.chomp
      if input == 'save'
        puts 'game saved!'
        # error, will loop and never prompt for guess...
      elsif input == 'exit'
        # we want to trigger this loop somehow...
        puts 'goodbye!'
        return
      else
        valid_input = get_valid_char(input)
        play_round(valid_input)
      end

      if player_won?(@blank_word, @word)
        puts 'you win!'
        return
      end
    end
    puts 'guess you lost :('
  end
end

NewGame.new
