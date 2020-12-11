defmodule Day10 do
  @moduledoc false
  use Memoize

  def real_input do
    Utils.get_input(10, 1)
  end

  def sample_input do
    """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """
  end

  def sample_input2 do
    """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
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
    |> Enum.map(&String.to_integer/1)
  end

  def solve(input) do
    [0 | input]
    |> Enum.sort()
    |> Enum.chunk_every(2, 1)
    |> Enum.map(fn
      [a, b] -> b - a
      [a] -> 3
    end)
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, fn x -> x + 1 end)
    end)
  end

  def solve2(input) do
    adapters = ([0, Enum.max(input) + 3] ++ input) |> Enum.sort()

    adapters
    |> adapter_to_potential_map()
    |> IO.inspect()
    |> get_possible_paths(0)
  end

  defmemo get_possible_paths(graph, start) do
    case Map.get(graph, start) do
      [] ->
        1
      l ->
        l
        |> Enum.map(fn x -> get_possible_paths(graph, x) end)
        |> Enum.sum()
    end
  end

  def adapter_to_potential_map(adapters) do
    adapters
    |> Enum.with_index()
    |> Enum.map(fn {joltage, idx} ->
      {joltage,
       Enum.slice(adapters, (idx + 1)..(idx + 3))
       |> Enum.filter(fn other_adapter -> other_adapter - joltage <= 3 end)}
    end)
    |> Map.new()
  end

  defmemo foo(a, b) do
    a + b
  end
end
