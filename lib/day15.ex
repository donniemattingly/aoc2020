defmodule Day15 do
  @moduledoc false

  def real_input do
    Utils.get_input(15, 1)
  end

  def sample_input do
    """
    0,3,6
    """
  end

  def sample_input2 do
    """
    """
  end

  def sample do
    sample_input()
    |> parse_input1
    |> solve1
  end

  def part1 do
    real_input1()
    |> parse_input1
    |> solve1
  end

  def sample2 do
    sample_input2()
    |> parse_input2
    |> solve2
  end

  def part2 do
    real_input2()
    |> parse_input2
    |> solve2
  end

  def real_input1, do: real_input()
  def real_input2, do: real_input()

  def parse_input1(input), do: parse_input(input)
  def parse_input2(input), do: parse_input(input)

  def solve1(input), do: solve(input)
  def solve2(input), do: solve(input)

  def parse_and_solve1(input), do: parse_input1(input) |> solve1
  def parse_and_solve2(input), do: parse_input2(input) |> solve2

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def run_turn(_, last, turn, stop) when turn == stop do
    last
  end

  def run_turn(turns, last, turn, stop) do
    # IO.inspect({last, turn, stop})
    # IO.inspect(turns)
    # IO.inspect({Map.get(turns, last), turn})

    case Map.get(turns, last) do
      nil -> run_turn(Map.put(turns, last, turn), 0, turn + 1, stop)
      x -> run_turn(Map.put(turns, last, turn), turn - x, turn + 1, stop)
    end
  end

  def solve(input) do
    turns =
      input
      |> Enum.with_index()
      |> Enum.map(fn {x, i} -> {x, i + 1} end)
      |> Map.new()

    starting_turn = Enum.count(input)

    run_turn(turns, Enum.reverse(input) |> hd, starting_turn, 30000000)
  end
end
