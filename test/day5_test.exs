defmodule Day5Test do
  use ExUnit.Case, async: true

  test "part 1" do
    assert Day5.parse_and_solve1('test') == 'test'
  end
end