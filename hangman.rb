class Player
  attr_reader :user_input
  
  def initalize
    @user_input = ''
  end

  def get_user_input
    @user_input = gets.chomp
  end
end