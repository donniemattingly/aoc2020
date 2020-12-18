defmodule Day17 do
  @moduledoc false

  def real_input do
    """
    #...#...
    #..#...#
    ..###..#
    .#..##..
    ####...#
    ######..
    ...#..#.
    ##.#.#.#
    """
  end

  def sample_input do
    """
    .#.
    ..#
    ###
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
    |> Enum.map(fn x ->
      Utils.split_each_char(x)
      |> Enum.map(fn
        "#" -> :active
        "." -> :inactive
      end)
    end)
    |> Utils.list_of_lists_to_map_by_point()
    |> Map.to_list()
    |> Enum.map(fn {{x, y}, v} -> {{x, y, 0, 0}, v} end) # change back for part 1
    |> Map.new()
  end

  def neighbors(point) do
    point
    |> Tuple.to_list()
    |> Enum.map(&Range.new(&1 - 1, &1 + 1))
    |> Enum.map(&Enum.to_list/1)
    |> Utils.List.cartesian()
    |> Enum.map(&List.to_tuple/1)
    |> Enum.filter(fn x -> x != point end)
  end

  def next_state(grid, point, state) do
    active_neighbors =
      point
      |> neighbors()
      |> Enum.map(&Map.get(grid, &1, :inactive))
      |> Enum.count(fn x -> x == :active end)

    case {active_neighbors, state} do
      {2, :active} -> :active
      {3, _} -> :active
      _ -> :inactive
    end
  end

  def get_search_space_dimensions(grid) do
    keys = Map.keys(grid)
    dims = keys |> hd |> tuple_size
    starting = for x <- 0..(dims - 1), do: {x, 0, 0}

    Enum.reduce(keys, starting, fn x, acc ->
      acc
      |> Enum.map(fn {dim, min, max} ->
        e = elem(x, dim)
        {dim, Enum.min([min, e]), Enum.max([max, e])}
      end)
    end)
  end

  def get_search_space(grid) do
    get_search_space_dimensions(grid)
    |> Enum.map(fn {_, min, max} -> Range.new(min - 1, max + 1) |> Enum.to_list() end)
    |> Utils.List.cartesian()
    |> Enum.map(&List.to_tuple/1)
  end

  def next_grid_state(grid) do
    grid
    |> get_search_space()
    |> Stream.map(fn point ->
      {point, next_state(grid, point, Map.get(grid, point, :inactive))}
    end)
    |> Map.new()
  end

  def render_3d_grid(grid) do
    [{_, x_min, x_max}, {_, y_min, y_max}, {_, z_min, z_max}] = get_search_space_dimensions(grid)

    z_min..z_max
    |> Enum.map(fn z ->
      {z, y_min..y_max
      |> Enum.map(fn y ->
        x_min..x_max
        |> Enum.map(fn x -> Map.get(grid, {x, y, z}, :inactive) end)
        |> Enum.map(fn
          :active -> "#"
          _ -> "."
        end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")}
    end)
    |> Enum.each(fn {z, grid} ->
      IO.puts("\n")
      IO.puts("z=#{z}")
      IO.puts(grid)
    end)
  end

  def render_slice(grid, z) do
    [{_, x_min, x_max}, {_, y_min, y_max}, {_, z_min, z_max}] = get_search_space_dimensions(grid)

    y_min..y_max
    |> Enum.map(fn y ->
      x_min..x_max
      |> Enum.map(fn x -> Map.get(grid, {x, y, z}, :inactive) end)
      |> Enum.map(fn
        :active -> "#"
        _ -> "."
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def solve(input) do
    input
    |> next_grid_state()
    |> next_grid_state()
    |> next_grid_state()
    |> next_grid_state()
    |> next_grid_state()
    |> next_grid_state()
  end
end
