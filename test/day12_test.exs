defmodule Day12Test do
  use ExUnit.Case, async: true

  test "rotations right by 90 work" do
    input = "R90\nF10\n"
    instructions = Day12.parse_input(input)
    {dir, x, y} = Day12.move_ferry(instructions)

    assert dir == :s
    assert y == -10
  end
end
