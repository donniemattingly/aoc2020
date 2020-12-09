defmodule Day9 do
  @moduledoc false

  def real_input do
    Utils.get_input(9, 1)
  end

  def sample_input do
    """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """
  end

  def sample_input2, do: sample_input()

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

  def is_num_some_sum_of_prev(chunk) do
    {nums, [test]} = Enum.split(chunk, -1)

    {test,
     for(x <- nums, y <- nums, do: {x, y})
     |> Enum.filter(fn {x, y} -> x != y end)
     |> Enum.map(fn {x, y} -> x + y end)
     |> Enum.any?(fn x -> x == test end)}
  end

  def num_not_composed_of_prev(nums, pre_size) do
    nums
    |> Enum.chunk_every(pre_size + 1, 1)
    |> Enum.map(&is_num_some_sum_of_prev/1)
    |> Enum.filter(fn {num, is_composed} -> !is_composed end)
  end

  def get_weakness(nums, weak_num) do
    weak_chunk =
      Enum.count(nums)..2
      |> Enum.flat_map(fn size -> test_chunk_size(nums, weak_num, size) end)
      |> Enum.filter(fn {sum, chunk} -> sum == weak_num end)
      |> hd()
      |> elem(1)

    Enum.min(weak_chunk) + Enum.max(weak_chunk)
  end

  def test_chunk_size(nums, weak_num, size) do
    Enum.chunk_every(nums, size, 1)
    |> Enum.map(fn chunk -> {Enum.reduce(chunk, &Kernel.+/2), chunk} end)
  end

  def solve(input) do
    input
    |> num_not_composed_of_prev(25)
  end

  def solve2(input) do
    num = solve(input) |> hd |> elem(0)
    get_weakness(input, num)
  end
end
