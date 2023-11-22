class UserInputAction
  
  def initialize(argv)
    @argv = argv
  end

  def call
    @argv.empty? ? gets.chomp : @argv[0]
  end

end
