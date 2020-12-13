defmodule Day12 do
  @moduledoc false

  def real_input do
    Utils.get_input(12, 1)
  end

  def sample_input do
    """
    F10
    N3
    F7
    R90
    F11
    """
  end

  def sample_input2 do
    """
    F10
    N3
    F7
    R90
    F11
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
    |> Enum.map(&normalize_rotation/1)
  end

  def parse_instruction(instr) do
    {direction, amount} = String.split_at(instr, 1)

    {
      direction |> String.downcase() |> String.to_atom(),
      amount |> String.to_integer()
    }
  end

  def normalize_rotation({:r, amount}), do: {:r, Integer.floor_div(amount, 90)}
  def normalize_rotation({:l, amount}), do: {:r, -1 * Integer.floor_div(amount, 90)}
  def normalize_rotation(x), do: x

  def rotate(amt, dir) do
    dirs = %{
      n: 0,
      e: 1,
      s: 2,
      w: 3
    }

    reverse = dirs |> Map.to_list() |> Enum.map(fn {k, v} -> {v, k} end) |> Map.new()

    new_dir = rem(rem(dirs[dir] + amt, 4) + 4, 4)
    reverse[new_dir]
  end

  @doc """
  By convention
    N = 0, E = 1, S = 2, W = 3
    L = moves the direction negatively (e.g. N -> W -> S -> E -> N)
    R = moves the direction positively (e.g. N -> E -> S -> W -> N)
  """
  def move_ferry(instructions), do: move_ferry(instructions, {:e, 0, 0})

  # Cardinal Directions
  def move_ferry([{:n, amt} | t], {dir, x, y}), do: move_ferry(t, {dir, x, y + amt})
  def move_ferry([{:s, amt} | t], {dir, x, y}), do: move_ferry(t, {dir, x, y - amt})
  def move_ferry([{:e, amt} | t], {dir, x, y}), do: move_ferry(t, {dir, x + amt, y})
  def move_ferry([{:w, amt} | t], {dir, x, y}), do: move_ferry(t, {dir, x - amt, y})

  # Moving Forward
  def move_ferry([{:f, amt} | t], {:n, x, y}), do: move_ferry(t, {:n, x, y + amt})
  def move_ferry([{:f, amt} | t], {:s, x, y}), do: move_ferry(t, {:s, x, y - amt})
  def move_ferry([{:f, amt} | t], {:e, x, y}), do: move_ferry(t, {:e, x + amt, y})
  def move_ferry([{:f, amt} | t], {:w, x, y}), do: move_ferry(t, {:w, x - amt, y})

  # Rotations
  def move_ferry([{:l, amt} | t], {dir, x, y}), do: move_ferry(t, {rotate(amt, dir), x, y})
  def move_ferry([{:r, amt} | t], {dir, x, y}), do: move_ferry(t, {rotate(amt, dir), x, y})

  def move_ferry([], result), do: result

  def solve(input) do
    {_, x, y} = input |> move_ferry()

    abs(x) + abs(y)
  end

  def rotate_waypoint({:r, 1}, {x, y}), do: {y, -x}
  def rotate_waypoint({:r, 2}, {x, y}), do: {-x, -y}
  def rotate_waypoint({:r, 3}, {x, y}), do: {y, -x}
  def rotate_waypoint({:r, -1}, {x, y}), do: {-y, x}
  def rotate_waypoint({:r, -2}, {x, y}), do: {-x, -y}
  def rotate_waypoint({:r, -3}, {x, y}), do: {y, -x}

  @doc """
  By convention
    N = 0, E = 1, S = 2, W = 3
    L = moves the direction negatively (e.g. N -> W -> S -> E -> N)
    R = moves the direction positively (e.g. N -> E -> S -> W -> N)
  """
  def move_ferry_and_waypoint(instructions),
    do: move_ferry_and_waypoint(instructions, {0, 0}, {10, 1})

  # Cardinal Directions
  def move_ferry_and_waypoint([{:n, amt} | t], {x, y}, {wx, wy}),
    do: move_ferry_and_waypoint(t, {x, y}, {wx, wy + amt})

  def move_ferry_and_waypoint([{:s, amt} | t], {x, y}, {wx, wy}),
    do: move_ferry_and_waypoint(t, {x, y}, {wx, wy - amt})

  def move_ferry_and_waypoint([{:e, amt} | t], {x, y}, {wx, wy}),
    do: move_ferry_and_waypoint(t, {x, y}, {wx + amt, wy})

  def move_ferry_and_waypoint([{:w, amt} | t], {x, y}, {wx, wy}),
    do: move_ferry_and_waypoint(t, {x, y}, {wx - amt, wy})

  # Moving Forward
  def move_ferry_and_waypoint([{:f, amt} | t], {x, y}, {wx, wy}),
    do: move_ferry_and_waypoint(t, {x + amt * wx, y + amt * wy}, {wx, wy})

  # Rotations
  def move_ferry_and_waypoint([rotation | t], {x, y}, {wx, wy}),
    do: move_ferry_and_waypoint(t, {x, y}, rotate_waypoint(rotation, {wx, wy}))

  def move_ferry_and_waypoint([], result, waypoint), do: {result, waypoint}

  def solve2(input) do
    {{x, y}, waypoint} = input |> move_ferry_and_waypoint() |> IO.inspect()

    abs(x) + abs(y)
  end
end
