defmodule Day1 do
  @moduledoc false

  def real_input do
    Utils.get_input(1, 1)
  end

  def sample_input do
    """
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

  def parse_and_solve1(input),
      do: parse_input1(input)
          |> solve1
  def parse_and_solve2(input),
      do: parse_input2(input)
          |> solve2

  def parse_input(input) do
    input
    |> Utils.split_lines
    |> Enum.map(&String.to_integer/1)
  end

  def solve(input) do
    input

    {x, y} = (for x <- input, y <- input, do: {x, y})
             |> Enum.filter(fn {x, y} -> x + y == 2020 end)
             |> hd

    x * y
  end

  def solve2(input) do
    {x, y, z} = (for x <- input, y <- input, z <- input, do: {x, y, z})
                |> Enum.filter(fn {x, y, z} -> x + y + z == 2020 end)
                |> hd
    x * y * z
  end
end
