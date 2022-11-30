
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



player = Player.new
player.user_input = gets.chomp
p player.input_ok?(player.user_input)
