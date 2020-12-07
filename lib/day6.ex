defmodule Day6 do
  @moduledoc false

  def real_input do
    Utils.get_input(6, 1)
  end

  def sample_input do
    """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b

    """
  end

  def sample_input2 do
    """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
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
    |> String.split("\n\n")
  end

  def solve(input) do
    input
    |> Enum.map(fn x -> String.replace(x, ~r/\s/, "") end)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def count_for_entry(entry) do
    entry
    |> Utils.split_lines()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(fn x, acc -> MapSet.intersection(x, acc) end)
    |> MapSet.size()
  end

  def solve2(input) do
    input
    |> Enum.map(&count_for_entry/1)
    |> Enum.sum()
  end
end
