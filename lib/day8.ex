defmodule Day8 do
  @moduledoc false

  def real_input do
    Utils.get_input(8, 1)
  end

  def sample_input do
    """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
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
    |> Enum.map(&parse_instruction/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {instr, i}, acc -> Map.put(acc, i, instr) end)
  end

  def parse_instruction("nop " <> amt), do: {:noop, String.to_integer(amt)}
  def parse_instruction("acc " <> amt), do: {:acc, String.to_integer(amt)}
  def parse_instruction("jmp " <> amt), do: {:jmp, String.to_integer(amt)}

  def execute(instructions) do
    do_execute(instructions, 0, 0, MapSet.new())
  end

  def do_execute(instructions, ip, acc, visited) do
    if MapSet.member?(visited, ip) do
      {:loop, acc}
    else
      case Map.get(instructions, ip) do
        {:noop, _} -> do_execute(instructions, ip + 1, acc, MapSet.put(visited, ip))
        {:acc, amt} -> do_execute(instructions, ip + 1, acc + amt, MapSet.put(visited, ip))
        {:jmp, amt} -> do_execute(instructions, ip + amt, acc, MapSet.put(visited, ip))
        _ -> {:completes, ip, acc, visited}
      end
    end
  end

  def solve(input) do
    input
    |> execute
  end

  def get_alternate_instructions(instructions) do
    instructions
    |> Map.keys()
    |> Enum.map(fn k ->
      case Map.get(instructions, k) do
        {:noop, amt} -> Map.put(instructions, k, {:jmp, amt})
        {:jmp, amt} -> Map.put(instructions, k, {:noop, amt})
        _ -> instructions
      end
    end)
  end

  def solve2(input) do
    input
    |> get_alternate_instructions()
    |> Enum.map(&execute/1)
    |> Enum.filter(fn x -> elem(x, 0) != :loop end)
  end
end
