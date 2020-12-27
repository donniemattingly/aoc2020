defmodule Day25 do
  @moduledoc false
  require Integer

  def real_input do
    Utils.get_input(25, 1)
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
  def solve2(input), do: solve(input)

  def parse_and_solve1(input), do: parse_input1(input) |> solve1
  def parse_and_solve2(input), do: parse_input2(input) |> solve2

  def parse_input(input) do
    input
  end

  def transform(subject_num, loop_size) do
    rem(pow(subject_num, loop_size) |> floor(), 20_201_227)
  end

  def get_loop_size(public_key) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(
      &Task.async(fn ->
        {&1, transform(7, &1)}
      end)
    )
    |> Stream.map(&Task.await(&1))
    |> Stream.filter(fn {_, val} -> val == public_key end)
    |> Utils.Stream.pop()
  end

  # def get_loop_size(public_key), do: get_loop_size(public_key, 7, 1)

  # def get_loop_size(public_key, subject_num, current_size) do
  #   case transform(subject_num, current_size) do
  #     next when next == public_key -> current_size
  #     _ -> get_loop_size(public_key, 7, current_size + 1)
  #   end
  # end

  def pow(n, k), do: pow(n, k, 1)
  defp pow(_, 0, acc), do: acc
  defp pow(n, k, acc), do: pow(n, k - 1, n * acc)

  def solve(input) do
    key1 = 8335663
    key2 = 8614349

    {:ok, a} = Utils.Fast.get_loop_size(key1)
    {:ok, b} = Utils.Fast.get_loop_size(key2)

    IO.inspect({a, b})

    Utils.Fast.transform(key1, b)
  end
end
