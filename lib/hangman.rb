# create instance of new game
class NewGame
  attr_accessor :incorrect_guesses_left, :user_input
  attr_reader :word

  def initialize
    @user_input = ''
    @incorrect_guesses_left = 10
    @word = 'corndog'
    @attempted_guesses = []
    @blank_word = nil
    play_game
  end

  def ask_user
    until input_ok?(@user_input)
      p 'enter your guess: '
      @user_input = gets.chomp
    end
  end

  # check input contains only uppercase or lowercase letters, and is only 1chr long
  def input_ok?(input)
    input.length == 1 && (input.count('^A-Z').zero? || input.count('^a-z').zero?)
  end

  def generate_blank(answer)
    blank_letters = ''
    answer.length.times do
      blank_letters += '_'
    end
    blank_letters
  end

  def update_blank(blank, answer, user_input)
    answer.length.times do |i|
      blank[i] = answer[i] if user_input == answer[i]
    end
  end

  # def already_guessed?(user_input, previous_guesses)
  #   previous_guesses.length.times do |i|
  #     return true if user_input == previous_guesses[i]
  #   end
  #   false
  # end

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

  def player_won?(blank, answer)
    blank == answer
  end

  def play_game
    until @incorrect_guesses_left.zero?

      @player.ask_user

      play_round(@player.user_input)

      if player_won?(@blank_word, @word)
        p 'you win!'
        return
      end

      @player.user_input = ''
    end
    p 'guess you lost :('
  end
end

new_game = NewGame.new
player = Player.new
new_game.play_game
