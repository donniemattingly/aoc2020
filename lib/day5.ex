defmodule Day5 do
  @moduledoc false

  def real_input do
    Utils.get_input(5, 1)
  end

  def sample_input do
    """
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
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

  def parse_and_solve1(input), do: parse_input1(input) |> solve1
  def parse_and_solve2(input), do: parse_input2(input) |> solve2

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_boarding_group/1)
  end

  def parse_boarding_group(group) do
    {col, row} = String.split_at(group, 7)
    {parse_col(col), parse_row(row)}
  end

  def parse_col(str), do: parse_binary_char(str, "F", "B")
  def parse_row(str), do: parse_binary_char(str, "L", "R")

  def parse_binary_char(str, zero, one) do
    str
    |> String.replace([zero, one], fn
      ^zero -> "0"
      ^one -> "1"
    end)
    |> Integer.parse(2)
    |> elem(0)
  end

  def get_seat_id({row, col}) do
    row * 8 + col
  end

  def solve(input) do
    input
    |> Enum.map(&get_seat_id/1)
    |> Enum.max()
  end

  def solve2(input) do
    input
    |> Enum.map(&get_seat_id/1)
    |> Enum.sort()
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn
      [a, b] -> b - a != 1
      _ -> false
    end)
    |> hd
    |> hd
    |> Kernel.+(1)
  end

  def testfn() do
    "food is good"
  end
end
