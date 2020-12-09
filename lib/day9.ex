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
    |> solve1(5)
  end

  def part1 do
    real_input1()
    |> parse_input1
    |> solve1(25)
  end

  def sample2 do
    sample_input2()
    |> parse_input2
    |> solve2(5)
  end

  def part2 do
    real_input2()
    |> parse_input2
    |> solve2(25)
  end

  def real_input1, do: real_input()
  def real_input2, do: real_input()

  def parse_input1(input), do: parse_input(input)
  def parse_input2(input), do: parse_input(input)

  def solve1(input, size), do: solve(input, size)

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&String.to_integer/1)
  end

  def is_num_some_sum_of_prev(chunk) do
    {nums, [test]} = Enum.split(chunk, -1)

      l =  for(x <- nums, y <- nums, do: {x, y})
     |> Stream.filter(fn {x, y} -> x != y end)
     |> Stream.map(fn {x, y} -> x + y end)
     |> Stream.filter(fn x -> x == test end)
     |> Stream.take(1)
     |> Enum.to_list

     case l do
      [h] -> {test, true}
      [] -> {test, false}
     end
  end

  def num_not_composed_of_prev(nums, pre_size) do
    nums
    |> Stream.chunk_every(pre_size + 1, 1)
    |> Stream.map(&is_num_some_sum_of_prev/1)
    |> Stream.filter(fn {_, is_composed} -> !is_composed end)
    |> Stream.take(1)
    |> Enum.to_list
  end

  def get_weakness(nums, weak_num) do
    chunk =
      2..Enum.count(nums)
      |> Stream.flat_map(&Stream.chunk_every(nums, &1, 1))
      |> Stream.map(fn chunk -> {Enum.sum(chunk), chunk} end)
      |> Stream.filter(fn {sum, _} -> sum == weak_num end)
      |> Stream.take(1)
      |> Enum.to_list()
      |> hd
      |> elem(1)

      Enum.min(chunk) + Enum.max(chunk)
  end

  def solve(input, size) do
    input
    |> num_not_composed_of_prev(size)
  end

  def solve2(input, size) do
    num = solve(input, size) |> hd |> elem(0)
    get_weakness(input, num)
  end
end
