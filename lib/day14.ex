defmodule Day14 do
  @moduledoc false

  def real_input do
    Utils.get_input(14, 1)
  end

  def sample_input do
    """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """
  end

  def sample_input2 do
    """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
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

  def solve1(input), do: solve(input)

  def parse_and_solve1(input), do: parse_input1(input) |> solve1
  def parse_and_solve2(input), do: parse_input2(input) |> solve2

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_line/1)
  end

  def parse_input2(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_line2/1)
  end

  def mask_fn_from_string(mask) do
    ones = String.replace(mask, "X", "0") |> Integer.parse(2) |> elem(0)
    zeros = String.replace(mask, "X", "1") |> Integer.parse(2) |> elem(0)
    fn num -> num |> Bitwise.bor(ones) |> Bitwise.band(zeros) end
  end

  def parse_line("mask = " <> mask) do
    {:mask, mask_fn_from_string(mask)}
  end

  def parse_line("mem[" <> memory) do
    memory
    |> String.replace(~r/[\[\]]/, "")
    |> String.trim()
    |> String.split(" = ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def parse_line2("mask = " <> mask) do
    {:masks,
     mask
     |> String.to_charlist()
     |> Enum.reduce([''], fn
       ?0, acc -> Enum.map(acc, &[?X | &1])
       ?X, acc -> Enum.map(acc, &[?0 | &1]) ++ Enum.map(acc, &[?1 | &1])
       ?1, acc -> Enum.map(acc, &[?1 | &1])
     end)
     |> Enum.map(&Enum.reverse/1)
     |> Enum.map(&List.to_string/1)
     |> Enum.map(&mask_fn_from_string/1)}
  end

  def parse_line2(str), do: parse_line(str)

  def perform_instructions(instructions) do
    do_perform_instructions(instructions, nil, %{})
  end

  def do_perform_instructions([{:mask, maskfn} | rest], _mask, memory) do
    do_perform_instructions(rest, maskfn, memory)
  end

  def do_perform_instructions([{loc, val} | rest], current_mask, memory) do
    new_mem = Map.put(memory, loc, current_mask.(val))
    do_perform_instructions(rest, current_mask, new_mem)
  end

  def do_perform_instructions([], _, memory), do: memory

  def solve(input) do
    input
    |> perform_instructions()
    |> Map.values()
    |> Enum.sum()
  end

  def perform_instructions2(instructions) do
    do_perform_instructions2(instructions, nil, %{})
  end

  def do_perform_instructions2([{:masks, masks} | rest], _masks, memory) do
    do_perform_instructions2(rest, masks, memory)
  end

  def do_perform_instructions2([{loc, val} | rest], current_masks, memory) do
    new_mem =
      current_masks
      |> Enum.reduce(memory, fn x, acc ->
        Map.put(acc, x.(loc), val)
      end)

    do_perform_instructions2(rest, current_masks, new_mem)
  end

  def do_perform_instructions2([], _, memory), do: memory

  def solve2(input) do
    input
    |> perform_instructions2()
    |> Map.values()
    |> Enum.sum()
  end
end
