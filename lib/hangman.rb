# check for valid input
module CheckInput
  # check input contains only uppercase or lowercase letters, and is only 1chr long
  def input_ok?(input)
    input.length == 1 && (input.count('^A-Z').zero? || input.count('^a-z').zero?)
  end
end

# create instance of player
class Player
  include CheckInput
  attr_accessor :user_input

  def initalize
    @user_input = ''
  end
end

# create instance of new game
class NewGame
  attr_accessor :incorrect_guesses_left
  attr_reader :answer

  def initalize
    @incorrect_guesses_left = 10
    @answer = 'corndog'
  end

  def display_blank(answer)
    blank_letters = ''
    answer.length.times do |i|
      blank_letters += '_'
    end

  end

  def play_round(player_input)
    p "Incorrect guesses remaining: #{@incorrect_guesses_left}"

  end
end

player = Player.new
player.user_input = gets.chomp
p player.input_ok?(player.user_input)
