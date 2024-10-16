class Player
  attr_reader :name, :mark_type

  def initialize(name, mark_type)
    @name = name
    @mark_type = mark_type
  end
end