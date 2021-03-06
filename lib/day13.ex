defmodule Day13 do
  @moduledoc false

  def real_input do
    Utils.get_input(13, 1)
  end

  def sample_input do
    """
    """
  end

  def sample_input2 do
    """
    1789,37,47,1889
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
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.with_index
    |> Enum.reject(fn {x, _} -> x == "x" end)
    |> Enum.map(fn {x, idx} -> {String.to_integer(x), idx} end)
  end

  def brute_force(times) do
    Stream.iterate(2, & &1 + 1)
    |> Stream.drop_while(fn x -> !test_timestamp(times, x) end)
    |> Utils.Stream.pop()
  end

  def step_increasing(times), do: step_increasing(times, 2, 1)

  def step_increasing([{bus, offset} | rest], count, cumulative_buses) do
    new_count = Stream.iterate(count, & &1 + cumulative_buses)
    |> Stream.drop_while(fn timestamp -> rem(timestamp + offset, bus) != 0  end)
    |> Utils.Stream.pop()

    step_increasing(rest, new_count, cumulative_buses * bus)
  end

  def step_increasing([], count, _) do
    count
  end

  def test_timestamp(times, timestamp) do
    times
    |> Enum.all?(fn {time, offset} -> rem(timestamp + offset, time) == 0 end)
  end

  def solve(input) do
    input
    |> step_increasing()
  end

  def test_fastutils() do
    Utils.Fast.test_timestamp(10, [1, 2, 3], [2, 4, 6])
  end
end
