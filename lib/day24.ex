defmodule Day24 do
  @moduledoc false

  def real_input do
    Utils.get_input(24, 1)
  end

  def sample_input do
    """
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
    """
  end

  def sample_input2 do
    sample_input()
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
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    get_directions(line, []) |> Enum.reverse()
  end

  def get_directions(line, parsed) do
    case parse_direction(line) do
      nil -> parsed
      {dir, rest} -> get_directions(rest, [dir | parsed])
    end
  end

  def parse_direction("se" <> rest), do: {:se, rest}
  def parse_direction("ne" <> rest), do: {:ne, rest}
  def parse_direction("sw" <> rest), do: {:sw, rest}
  def parse_direction("nw" <> rest), do: {:nw, rest}
  def parse_direction("e" <> rest), do: {:e, rest}
  def parse_direction("w" <> rest), do: {:w, rest}
  def parse_direction(""), do: nil

  def direction_to_translation(dir) do
    case dir do
      :w -> {-1, 1, 0}
      :sw -> {-1, 0, 1}
      :se -> {0, -1, 1}
      :e -> {1, -1, 0}
      :ne -> {1, 0, -1}
      :nw -> {0, 1, -1}
    end
  end

  def translate({x, y, z}, dir) do
    {dx, dy, dz} = direction_to_translation(dir)
    {x + dx, y + dy, z + dz}
  end

  def walk_directions(directions) do
    directions
    |> Enum.reduce({0, 0, 0}, fn dir, last ->
      translate(last, dir)
    end)
  end

  def get_flipped_tiles(input) do
    input
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, walk_directions(x), true, fn x -> !x end)
    end)
  end

  def neighbors(tile) do
    [:w, :sw, :se, :e, :ne, :nw]
    |> Enum.map(fn x -> translate(tile, x) end)
  end

  def num_black_neighbors(tile, map) do
    neighbors(tile) |> Enum.map(fn x -> Map.get(map, x, false) end) |> Enum.count(& &1)
  end

  @doc """
  true -> black
  false -> white
  """
  def next_state(tile, map) do
    tile_is_black = Map.get(map, tile, false )
    num_black_neighbors = num_black_neighbors(tile, map)

    case {tile_is_black, num_black_neighbors} do
      {true, 0} -> false
      {true, x} when x > 2 -> false
      {false, 2} -> true
      _ -> tile_is_black
    end
  end

  def extract_min_max_for_tuple(point, index) do
    {point |> elem(0) |> elem(index), point |> elem(1) |> elem(index)}
  end
  def get_bounds(map) do
    [0, 1, 2]
    |> Enum.map(fn x ->
      Map.keys(map)
      |> Enum.min_max_by(fn point -> elem(point, x) end)
      |> extract_min_max_for_tuple(x)
    end)
  end

  def generation(map) do
    # [{min_x, max_x}, {min_y, max_y}, {min_z, max_z}] = get_bounds(map)
    # to_test = for x <- min_x - 1..max_x + 1, y <- min_y - 1..max_y + 1, z <- min_z - 1..max_z + 1, do: {x, y, z}

    Map.keys(map)
    |> Enum.flat_map(&neighbors/1)
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.map(fn x -> {x, next_state(x, map)} end)
    |> Map.new()
  end

  def solve(input) do
    input
    |> get_flipped_tiles()
    |> num_black_tiles()
  end

  def num_black_tiles(map) do
    map
    |> Map.values()
    |> Enum.count(& &1)
  end

  def solve2(input) do
    initial = get_flipped_tiles(input)
    1..100
    |> Enum.reduce(initial, fn x, acc ->
      IO.inspect(num_black_tiles(acc), label: "Day: #{x - 1}")
      generation(acc)
    end)
    |> num_black_tiles()
  end
end
