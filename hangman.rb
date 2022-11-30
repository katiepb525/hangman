module CheckInput
  # check input contains only uppercase or lowercase letters, and is only 1chr long
  def input_ok?(input)
    input.length == 1 && (input.count('^A-Z').zero? || input.count('^a-z').zero?)
  end
end

class Player
  include CheckInput
  attr_reader :user_input

  def initalize
    @user_input = ''
  end

  def get_user_input
    @user_input = gets.chomp
  end
end

player = Player.new
player.get_user_input
p player.input_ok?(player.user_input)
