defmodule Day20 do
  @moduledoc false
  use Memoize

  def real_input do
    Utils.get_input(20, 1)
  end

  def sample_input do
    Utils.get_input(20, 0)
  end

  def sample_input2 do
    Utils.get_input(20, 0)
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
    |> String.split("\n\n")
    |> Enum.map(&parse_tile/1)
  end

  def parse_tile(raw_tile) do
    [name | grid] = Utils.split_lines(raw_tile)

    tile =
      grid
      |> Enum.map(fn line ->
        line
        |> Utils.split_each_char()
        |> Enum.map(fn
          "#" -> 1
          "." -> 0
        end)
      end)
      |> Matrex.new()

    [id] = Regex.run(~r/Tile (\d+):/, name, capture: :all_but_first)
    {String.to_integer(id), tile}
  end

  def put_matrix_in_larger_empty_one(matrix, size, pos) do
    tile_size = Matrex.size(matrix)
    full_size = size * elem(tile_size, 0)

    Matrex.zeros(full_size)
  end

  def get_sides(matrix) do
    {w, h} = Matrex.size(matrix)

    [
      Matrex.row(matrix, 1),
      Matrex.row(matrix, w),
      Matrex.column(matrix, 1),
      Matrex.column(matrix, w)
    ]
    |> Enum.map(&Matrex.to_list/1)
    |> Enum.flat_map(fn x -> [x, Enum.reverse(x)] end)
  end

  def get_corners(input) do
    ids_with_sides = input |> Enum.map(fn {id, tile} -> {id, get_sides(tile)} end)

    ids_with_sides
    |> Enum.flat_map(fn {name, sides} ->
      Enum.map(sides, fn side -> {name, side} end)
    end)
    |> Enum.reduce(%{}, fn {id, side}, acc ->
      Map.update(acc, side, MapSet.new([id]), &MapSet.put(&1, id))
    end)
    |> Map.values()
    |> Enum.filter(fn x -> MapSet.size(x) == 1 end)
    |> Enum.flat_map(&MapSet.to_list/1)
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.filter(fn {_, b} -> b == 4 end)
    |> Enum.map(fn {a, _} -> a end)
  end

  def solve(input) do
    get_corners(input)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  @doc """
  Plan:
    - assume any corner can be the top left
    - take one of the corners
    - for each rotation of that corner
      - attempt to find a tile that matches its edge, in reading
      order
      - i.e. iterate through all tiles (inc rotations of each) checking
      for edge equality
      - if you find a match, update the current tile to that pos and recurse
      - if not, return an :error
  """
  def assemble_map(tiles, starting_tile_id, macro_size) do
    available_tiles =
      tiles |> Map.keys() |> MapSet.new() |> remove_other_rotations_of_tile(starting_tile_id)

    current_map = Map.put(%{}, {1, 1}, starting_tile_id)
    assemble_map(tiles, available_tiles, current_map, starting_tile_id, 2, 1, macro_size)
  end

  @doc """
  Positions are *1 indexed!*

  tiles_map = original input id => tile matrix
  available_tiles = Set of ids
  current_map = current progress, map of pos => {id, rotation}
  cur_x, cur_y = tile we're testing for neighbors
  macro_size = number of tiles per side of grid
  """
  def assemble_map(
        tiles_map,
        available_tiles,
        current_map,
        current_tile_id,
        cur_x,
        cur_y,
        macro_size
      ) do
    cur_matrix = tiles_map[current_tile_id]

    possible =
      available_tiles
      |> Enum.filter(fn tile -> test_tile(tile, cur_x, cur_y, current_map, tiles_map) end)
      |> Enum.flat_map(fn option ->
        new_available = available_tiles |> remove_other_rotations_of_tile(option)
        new_current = Map.put(current_map, {cur_x, cur_y}, option)
        {next_x, next_y} = next_pos(cur_x, cur_y, macro_size)

        case next_y > macro_size do
          true ->
            IO.inspect({next_x, next_y}, label: "exited on")
            new_current

          false ->
            assemble_map(
              tiles_map,
              new_available,
              new_current,
              option,
              next_x,
              next_y,
              macro_size
            )
        end
      end)
  end

  def next_pos(x, y, size) when x == size, do: {1, y + 1}
  def next_pos(x, y, size), do: {x + 1, y}

  def remove_other_rotations_of_tile(available_tiles, {id, _}) do
    rotations =
      0..5
      |> Enum.map(&{id, &1})
      |> MapSet.new()

    MapSet.difference(available_tiles, rotations)
  end

  def test_tile(tile_id, x, y, current_map, tiles_map) do
    tile = tiles_map[tile_id]
    left = Map.get(tiles_map, current_map[{x - 1, y}])
    top = Map.get(tiles_map, current_map[{x, y - 1}])
    left_to_right_neighbor?(left, tile) and top_to_bottom_neighbor?(top, tile)
  end

  def tile_to_annotated_list_of_rotations(tile_id, tiles_map) do
    tiles_map[tile_id]
    |> get_possible_rotations()
    |> Enum.with_index()
    |> Enum.map(fn {tile, index} ->
      {{tile_id, index}, tile}
    end)
  end

  def get_possible_rotations(matrix) do
    [
      matrix,
      matrix |> Utils.Matrix.rotate_clockwise(),
      matrix |> Utils.Matrix.rotate_clockwise() |> Utils.Matrix.rotate_clockwise(),
      matrix
      |> Utils.Matrix.rotate_clockwise()
      |> Utils.Matrix.rotate_clockwise()
      |> Utils.Matrix.rotate_clockwise(),
      matrix |> Utils.Matrix.horizontal_reflection(),
      matrix |> Utils.Matrix.vertical_reflection()
    ]
  end

  # nil here means there was no
  def left_to_right_neighbor?(nil, _), do: true

  def left_to_right_neighbor?(m1, m2) do
    {s, _} = Matrex.size(m1)
    Matrex.column(m1, s) == Matrex.column(m2, 1)
  end

  def top_to_bottom_neighbor?(nil, _), do: true

  def top_to_bottom_neighbor?(m1, m2) do
    {s, _} = Matrex.size(m1)
    Matrex.row(m1, s) == Matrex.row(m2, 1)
  end

  def solve2(input) do
    macro_size = 3
    raw_tiles = input |> Map.new()
    corners = for x <- raw_tiles |> Map.keys(), y <- 0..5, do: {x, y}

    tiles =
      raw_tiles
      |> Map.keys()
      |> Enum.flat_map(&tile_to_annotated_list_of_rotations(&1, raw_tiles))
      |> Map.new()

    layout =
      corners
      |> Enum.map(&assemble_map(tiles, &1, 3))
      |> Enum.reject(&Enum.empty?/1)
      |> hd
      |> Enum.map(fn {point, tile_id} ->
        generate_sparse_matrix_with_tile(point, tiles[tile_id], macro_size)
      end)
      |> Enum.reduce(&Matrex.add/2)
  end

  def render_matrix(matrix) do
    Matrex.to_list_of_lists(matrix)
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn
        x when x >= 1 -> "#"
        _ -> "."
      end)
      |> Enum.join("")
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  def generate_sparse_matrix_with_tile(point, tile_matrix, macro_size) do
    zeros_map =
      for(x <- 1..macro_size, y <- 1..macro_size, do: {x, y})
      |> Enum.map(fn p -> {p, Matrex.zeros(8)} end)
      |> Map.new()

    map_with_tile = Map.put(zeros_map, point, Matrex.submatrix(tile_matrix, 2..9, 2..9))

    rows =
      1..macro_size
      |> Enum.map(fn row ->
        1..macro_size
        |> Enum.map(&Map.get(map_with_tile, {&1, row} |> IO.inspect()))
        |> Enum.reduce(&Matrex.concat(&2, &1, :columns))
      end)
      |> Enum.reduce(&Matrex.concat(&2, &1, :rows))
  end
end
