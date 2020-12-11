defmodule Day11 do
  @moduledoc false

  def real_input do
    Utils.get_input(11, 1)
  end

  def sample_input do
    """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
  end

  def sample_input2 do
    """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
  end

  def sample_input3 do
    """
    .......#.
    ...#.....
    .#.......
    .........
    ..#L....#
    ....#....
    .........
    #........
    ...#.....
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
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, x} ->
      row
      |> Utils.split_each_char()
      |> Enum.with_index()
      |> Enum.map(fn {char, y} -> {{x, y}, char} end)
    end)
    |> Enum.map(fn
      {point, "."} -> {point, :floor}
      {point, "L"} -> {point, :empty}
      {point, "#"} -> {point, :full}
    end)
    |> Map.new()
  end

  def adjacent_seats({x, y}) do
    [
      {x - 1, y},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ]
  end

  def get_first_visible_seat_in_direction(p = {x, y}, d = {dx, dy}, map) do
    n = {x + dx, y + dy}

    case Map.get(map, n) do
      nil -> nil
      :floor -> get_first_visible_seat_in_direction(n, d, map)
      _ -> p
    end
  end

  def visible_seats(p = {x, y}, map) do
    deltas = [
      {-1, 0},
      {-1, -1},
      {-1, 1},
      {0, -1},
      {0, 1},
      {1, 0},
      {1, -1},
      {1, 1}
    ]

    deltas
    |> Enum.map(&get_first_visible_seat_in_direction(p, &1, map))
    |> Enum.filter(& &1 != p)
    |> Enum.filter(& &1)
  end

  def update_tile(p, :floor, _), do: {p, :floor}

  def update_tile(p, :empty, map) do
    has_neighbor =
      adjacent_seats(p)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.any?(fn x -> x == :full end)

    if !has_neighbor do
      {p, :full}
    else
      {p, :empty}
    end
  end

  def update_tile(p, :full, map) do
    full_neighbors =
      adjacent_seats(p)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.count(fn x -> x == :full end)

    if full_neighbors >= 4 do
      {p, :empty}
    else
      {p, :full}
    end
  end

  def update_tile2(p, :floor, _), do: {p, :floor}

  def update_tile2(p, :full, map) do
    Map.put(map, p, :focus)

    full_neighbors =
      visible_seats(p, map)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.count(fn x -> x == :full end)

    if full_neighbors >= 5 do
      {p, :empty}
    else
      {p, :full}
    end
  end

  def update_tile2(p, :empty, map) do
    has_neighbor =
      visible_seats(p, map)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.any?(fn x -> x == :full end)

    if !has_neighbor do
      {p, :full}
    else
      {p, :empty}
    end
  end

  def tick(map) do
    Map.keys(map)
    |> Enum.map(fn p -> update_tile(p, Map.get(map, p), map) end)
    |> Map.new()
  end

  def tick2(map) do
    new = Map.keys(map)
    |> Enum.map(fn p -> update_tile2(p, Map.get(map, p), map) end)
    |> Map.new()

    p = {x, y} = {0, 0}
    seat = get_first_visible_seat_in_direction(p, {1, 0}, map)
    IO.inspect(seat, label: "visible seat going {0, 1} for {#{x}, #{y}}")

    v = visible_seats({0, 0}, map) |> IO.inspect
    map_with_highlights(map, {1, 0}, v) |> render

    new
  end

  def is_stable(old_map, new_map), do: old_map == new_map

  def do_ticks(map, old_map) do
    if is_stable(map, old_map) do
      map
    else
      tick(map)
      |> do_ticks(map)
    end
  end

  def do_ticks2(map, old_map, count \\ 0, limit \\ 4) do

    if is_stable(map, old_map) || count > limit do
      IO.puts("Stablized")
      map
    else
      tick2(map)
      |> do_ticks2(map, count + 1)
    end
  end

  def solve(input) do
    input
    |> do_ticks(nil)
    |> Map.to_list()
    |> Enum.filter(fn {k, v} -> v == :full end)
    |> Enum.count()
  end

  def solve2(input) do
    input
    |> do_ticks2(nil)
    |> Map.to_list()
    |> Enum.filter(fn {k, v} -> v == :full end)
    |> Enum.count()
  end

  def map_with_highlights(map, origin, neighbors) do
    neighbors
    |> Enum.reduce(map, fn x, acc -> Map.put(acc, x, :highlight) end)
    |> Map.put(origin, :origin)
  end

  def atom_to_symbol(:empty), do: "L"
  def atom_to_symbol(:floor), do: "."
  def atom_to_symbol(:full), do: "#"
  def atom_to_symbol(:highlight), do: "O" |> Utils.colorize(:green)
  def atom_to_symbol(:origin), do: "X" |> Utils.colorize(:red)

  def render(map) do
    {max_x, max_y} = Map.keys(map) |> Enum.max()
    {min_x, min_y} = Map.keys(map) |> Enum.filter(& &1) |> Enum.min()

    min_x..max_x
    |> Enum.map(fn x ->
      min_y..max_y
      |> Enum.map(&Map.get(map, {x, &1}))
      |> Enum.map(&atom_to_symbol/1)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    IO.puts("    ")
  end
end
