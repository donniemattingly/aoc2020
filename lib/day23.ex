defmodule Day23 do
  @moduledoc false

  alias Circle.Node, as: Node

  def real_input do
    "952438716"
  end

  def sample_input do
    """
    389125467
    """
  end

  def sample_input2 do
    """
    389125467
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
    |> Utils.split_each_char()
    |> Enum.map(&String.to_integer/1)
  end

  def solve(input) do
    circle = Circle.new(input)
    current = hd(input)
    {circle, _} = 1..100
    |> Enum.reduce({circle, current}, fn _, acc -> move(acc) end)

    render_circle(circle, circle[1])
    |> tl()
    |> Enum.join()
  end

  def solve2(raw_input) do
    input = raw_input ++ Enum.to_list(10..1000000)
    circle = Circle.new(input)
    current = hd(input)
    circle = move_times({circle, current}, 10000000)

    a = circle[1] |> Node.next()
    b = Node.next(a)

    Node.value(a) * Node.value(b)
  end

  def move_times({circle, current}, 0), do: circle
  def move_times({circle, current}, move) do
    if rem(move, 1000) == 0, do: IO.inspect(move, label: "at")
    move_times(move({circle, current}), move - 1)
  end

  def val, do: 902208073192
  def move({circle, current}) do
    {popped, new_circle} = Circle.pop_next_3(circle, current)
    # IO.inspect(popped |> Enum.map(&Node.value/1), label: "popped")
    destination = get_insertion_node(new_circle, current - 1) |> Node.value()
    # IO.inspect(destination, label: "destination")
    next_circle = Circle.insert(new_circle, destination, popped)
    next = next_circle[current] |> Node.next |> Node.value
    {next_circle, next}
  end

  def get_insertion_node(circle, -1) do
    max = circle |> Map.keys() |> Enum.reject(&is_atom/1) |> Enum.max()
    circle[max]
  end

  def get_insertion_node(circle, value) do
    case circle[value] do
      nil -> get_insertion_node(circle, value - 1)
      x -> x
    end
  end

  def render_circle(circle, start) do
    [Node.value(start) | render_circle(circle, Node.next(start), start)]
  end

  def render_circle(_, current, stop) when current == stop, do: []
  def render_circle(circle, current, stop) do
    [Node.value(current) | render_circle(circle, Node.next(current), stop)]
  end
end
