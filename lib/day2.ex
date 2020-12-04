defmodule Day2 do
  @moduledoc false

  def real_input do
    Utils.get_input(2, 1)
  end

  def sample_input do
    """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """
  end

  def sample_input2 do
    """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
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
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [min, max, char, pw] = Regex.run(~r/(\d+)-(\d+) (\w): (\w+)/, line)
  end

  def foo do
    fn x -> {num, rest} = Integer.parse("2"); num end
  end

  def count_letters(pw) do
    pw
    |> String.to_charlist
    |> Enum.reduce(Map.new(), fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def is_valid([min, max, char, pw]) do
    counts = count_letters(pw)
    char = char
           |> String.to_charlist
           |> hd
    minNum = String.to_integer(min)
    maxNum = String.to_integer(max)

    count = Map.get(counts, char, 0)

    IO.puts("count: #{count} min: #{minNum} max: #{maxNum}")
    count != nil && !(count > maxNum || count < minNum)
  end

  def is_valid2([min, max, char, pw]) do
    char = char |> String.to_charlist |> hd
    pwList = pw |> String.to_charlist
    minNum = String.to_integer(min) - 1
    maxNum = String.to_integer(max) - 1

    (Enum.at(pwList, minNum) == char || Enum.at(pwList, maxNum) == char) && !(
      Enum.at(pwList, minNum) == char && Enum.at(pwList, maxNum) == char)
  end

  def solve(input) do
    input
    |> Enum.map(&is_valid/1)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def solve2(input) do
    input
    |> Enum.map(&is_valid2/1)
    |> Enum.filter(& &1)
    |> Enum.count()
  end
end
