defmodule Day2Test do
  use ExUnit.Case, async: true

  test "part 1" do
    assert Day2.parse_and_solve1('test') == 'test'
  end
end