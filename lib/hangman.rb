# frozen-string-literal: true

require 'pry-byebug'
require 'yaml'

# all methods that print a string
module Display
  def display_round_info(blank, incorrect_guesses_left, attempted_guesses)
    puts blank.to_s
    puts "you have #{incorrect_guesses_left} guesses left."
    puts "previously tried guesses: #{attempted_guesses}"
    puts "type \'save\' to save at any time. type \'exit\' to exit\n at anytime."
  end

  def display_new_or_load_prompt
    puts "press 'L' to load a saved game.\n press 'N' to start a new game."
  end

  def display_win
    puts 'you win!'
  end

  def display_lose
    puts 'you lose :('
  end

  def display_exit
    puts 'bye!'
  end

  def display_save
    puts 'game saved!'
  end

  def display_guess_prompt
    puts 'enter your guess:'
  end

  def display_guess_again_prompt(input)
    puts "youve already guessed the letter #{input}."
  end

  def display_wrong_guess
    puts 'oops! wrong guess..'
  end

  def display_load_prompt
    puts 'choose a recent file to load..'
  end
end

# create instance of new game
class NewGame
  include Display
  attr_accessor :incorrect_guesses_left
  attr_reader :word

  # save game directory/filename
  @@directory = 'saved_games/'
  # array of different save file names
  @@save_files = ['save_1.yml', 'save_2.yml', 'save_3.yml']
  # save chosen by user
  @@chosen_save = ''

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
      display_new_or_load_prompt
      input = gets.chomp
      if input == 'L'
        # ask player to choose a save file
        choose_load
        # start game with saved values
      elsif input == 'N'
        play_game
      end
    end
  end

  # choose from the 3 most recent saves
  def choose_load
    display_load_prompt
    puts @@save_files
    @@chosen_save = gets.chomp
    # check if chosen save if valid
    until File.exist?("#{@@directory}#{@@chosen_save}")
      puts "that save doesn\'t exist.
      \nchoose another save."
      @@chosen_save = gets.chomp
    end
    deserialize
    play_game
  end

  # load saved values into game
  def deserialize
    save = YAML.load(File.read("#{@@directory}#{@@chosen_save}"))
    @incorrect_guesses_left = save[:incorrect_guesses_left]
    @word = save[:word]
    @attempted_guesses = save[:attempted_guesses]
    @blank_word = save[:blank_word]
  end

  def to_yaml
    YAML.dump({
                incorrect_guesses_left: @incorrect_guesses_left,
                word: @word,
                attempted_guesses: @attempted_guesses,
                blank_word: @blank_word
              })
  end

  def save_game
    puts 'chose a file to save to:'
    puts @@save_files
    @@chosen_save = gets.chomp

    until @@save_files.include?(@@chosen_save)
      puts 'please pick a valid save.'
      @@chosen_save = gets.chomp
    end
    File.open("#{@@directory}#{@@chosen_save}", 'w') { |file| file.write(to_yaml) }
    puts 'game saved.'
    nil

    # # check if chosen save if valid
    # if File.exist?("#{@@directory}#{@@chosen_save}")
    #   puts "would you like to overrwrite #{@@chosen_save?} y or n"
    #   input = gets.chomp
    #   if input = 'y'
    #     # save yaml file to chosen save
    #     File.open("#{@@directory}#{@@chosen_save}", 'w') { |file| file.write(to_yaml) }
    #     puts "game saved."
    #     return
    #   end

    # else

    # end
  end

  def get_valid_char(input)
    until input_ok?(input) == true && already_guessed?(input, @attempted_guesses) == false
      display_guess_again_prompt(input) if already_guessed?(input, @attempted_guesses) == true
      display_guess_prompt
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
    @attempted_guesses.push(user_input.downcase)

    former_blank = @blank_word.clone

    update_blank(@blank_word, @word, user_input.downcase)

    return unless former_blank == @blank_word

    @incorrect_guesses_left -= 1

    display_wrong_guess
  end

  def play_game
    input = ''
    until @incorrect_guesses_left.zero?
      display_round_info(@blank_word, @incorrect_guesses_left, @attempted_guesses)
      input = gets.chomp
      if input == 'save'
        save_game
        # exit_or_continue?
        return
      elsif input == 'exit'
        display_exit
        return
      else
        valid_input = get_valid_char(input)
        play_round(valid_input)
      end

      if player_won?(@blank_word, @word)
        display_win
        return
      end

    end
    display_lose
  end
end

NewGame.new
