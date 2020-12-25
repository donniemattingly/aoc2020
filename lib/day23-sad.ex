defmodule Day23Sad do
  @moduledoc false
  alias Utils.CircularList, as: CLL

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
  def solve2(input), do: solve(input)

  def parse_and_solve1(input), do: parse_input1(input) |> solve1
  def parse_and_solve2(input), do: parse_input2(input) |> solve2

  def parse_input(input) do
    input
    |> Utils.split_each_char()
    |> Enum.map(&String.to_integer/1)
  end

  def inspect_circle(circle) do
    circle |> CLL.to_list() |> IO.inspect()
    circle
  end

  def traverse_to_value(circle, val) do
    fun = fn x ->
      IO.inspect({x, val})
      x == val
    end

    case {CLL.next_until(circle, fun), val} do
      {nil, 0} -> traverse_to_value(circle, get_circle_max(circle))
      {nil, val} -> traverse_to_value(circle, val - 1)
      {x, _} -> x
    end
  end

  def get_circle_max(circle) do
    CLL.to_list(circle) |> Enum.max()
  end

  def move_old(circle) do
    IO.puts("\n----- move -----")
    {prev, [h | t]} = circle

    IO.puts("cups: #{prev |> Enum.reverse() |> Enum.join(" ")} (#{h}) #{t |> Enum.join(" ")}")

    current = CLL.current(circle)
    {popped, rest} = CLL.pop_n(circle |> CLL.next(), 3)

    IO.puts("pick up: #{Enum.join(popped, ", ")}")
    destination = traverse_to_value(rest, current - 1)

    IO.puts("destination: #{CLL.current(destination)}")

    destination
    |> CLL.next()
    |> CLL.push(popped)
    |> CLL.prev_until(fn x -> x == current end)
  end

  defmodule Node do
    defstruct prev: nil, next: nil, node: nil
  end

  def make_list(cups) do
    circle =
      Enum.chunk_every(cups, 3, 1)
      |> Enum.filter(fn x -> Enum.count(x) == 3 end)
      |> Enum.reduce(%{}, fn [prev, node, next], acc ->
        Map.put(acc, node, %Node{node: node, prev: prev, next: next})
      end)

    [first, second | _] = cups
    [last, second_last | _] = Enum.reverse(cups)

    circle
    |> Map.put(first, %Node{node: first, prev: last, next: second})
    |> Map.put(last, %Node{node: last, prev: second_last, next: first})
    |> Map.put(:head, hd(cups))
  end

  def render_list(circle), do: [circle[:head] | render_list(circle, circle[circle[:head]].next)]

  def render_list(circle, cur) do
    cond do
      circle[:head] == cur -> []
      true -> [cur | render_list(circle, circle[cur].next)]
    end
  end

  def pop3(circle, label) do
    a = circle[label]
    b = circle[a.next]
    c = circle[b.next]
    d = circle[c.next]

    popped = [a, b, c] |> Enum.map(fn x -> x.node end)

    new_circle =
      circle
      |> Map.update(a.prev, nil, fn x -> %{x | next: d.node} end)
      |> Map.update(d.node, nil, fn x -> %{x | prev: label} end)
      |> Map.delete(a.node)
      |> Map.delete(b.node)
      |> Map.delete(c.node)

    {popped, new_circle}
  end

  def insert3_at(circle, label, [a, b, c]) do
    cur_node = circle[label]

    circle
    |> Map.put(a, %Node{prev: label, node: a, next: b})
    |> Map.put(b, %Node{prev: a, node: b, next: c})
    |> Map.put(c, %Node{prev: b, node: c, next: cur_node.next})
    |> Map.update(label, nil, fn x -> %{x | next: a} end)
    |> Map.update(cur_node.next, nil, fn x -> %{x | prev: c} end)
  end

  def next(circle, label) do
    circle[circle[label].next]
  end

  def add_max_to_circle(circle) do
    max = Map.keys(circle) |> Enum.max()
    Map.put(circle, :max, max)
  end

  def move(circle, current) do
    IO.inspect(current, label: "current")
    {popped, new_circle} = pop3(circle, circle[current].next)
    IO.inspect(popped, label: "popped")
    insertion_node = get_insertion_node(new_circle, current - 1)
    IO.inspect(insertion_node.node, label: "destination")
    new = insert3_at(new_circle, insertion_node.node, popped)
    next = new[current] |> IO.inspect(label: "next")
    {next.next, new}
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

  def solve(input) do
    cur = hd(input)
    circle = make_list(input)

    1..10
    |> Enum.reduce({cur, circle}, fn _, {cur, circle} ->
      move(circle, cur)
    end)
  end
end
