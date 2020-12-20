defmodule Day18 do
  @moduledoc false

  def real_input do
    Utils.get_input(18, 1)
  end

  def sample_input do
    """
    8 * 3 + 3 * 4
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
    |> Utils.split_lines()
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input) do
    input
    |> Utils.split_each_char()
    |> Enum.filter(fn x -> x != " " end)
    |> Enum.map(fn
      "+" -> :plus
      "(" -> :left
      ")" -> :right
      "*" -> :mult
      x -> String.to_integer(x)
    end)
  end

  defguard is_operator(value) when value == :mult or value == :plus

  def convert_to_postfix(l), do: convert_to_postfix(l, [], :queue.new())

  def convert_to_postfix([h | t], operators, output) when is_number(h) do
    convert_to_postfix(t, operators, :queue.in(h, output))
  end

  def convert_to_postfix([:left | t], operators, output) do
    convert_to_postfix(t, [:left | operators], output)
  end

  def convert_to_postfix([:right | t], operators, output) do
    {ops_to_enqueue, [_ | rest]} = pop_operators(operators, [])
    output = ops_to_enqueue |> Enum.reduce(output, fn x, acc -> :queue.in(x, acc) end)
    convert_to_postfix(t, rest, output)
  end

  def convert_to_postfix([], operators, output) do
    operators |> Enum.reduce(output, fn x, acc -> :queue.in(x, acc) end) |> :queue.to_list()
  end

  def convert_to_postfix([op | t], operators, output) do
    {ops_to_enqueue, rest} = pop_operators_with_precedence(op, operators, [])
    output = ops_to_enqueue |> Enum.reduce(output, fn x, acc -> :queue.in(x, acc) end)
    convert_to_postfix(t, [op | rest], output)
  end

  def pop_operators_with_precedence(token, [op | rest] = operators, stack) when is_operator(op) do
    case {token, op} do
      {:mult, :plus} -> {stack, operators}
      _ -> pop_operators_with_precedence(token, rest, [op | stack])
    end
  end

  def pop_operators_with_precedence(_, operators, stack), do: {stack, operators}

  def pop_operators([op | rest], stack) when is_operator(op),
    do: pop_operators(rest, [op | stack])

  def pop_operators(operators, stack), do: {stack, operators}

  def rpn(expr), do: rpn(expr, [])
  def rpn([], [h | _]), do: h
  def rpn([h | t], stack) when is_number(h), do: rpn(t, [h | stack])

  def rpn([h | t], stack) do
    [a, b | rest] = stack

    case h do
      :plus -> rpn(t, [a + b | rest])
      :mult -> rpn(t, [a * b | rest])
    end
  end

  def render_expression(expr) do
    expr
    |> Enum.map(fn
      :mult -> "*"
      :plus -> "+"
      x -> x
    end)
    |> Enum.join(" ")
  end

  def solve(input) do
    input
    |> Enum.map(&convert_to_postfix/1)
    |> Enum.map(&rpn/1)
    |> Enum.sum()
  end
end
