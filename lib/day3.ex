defmodule Day3 do
  @moduledoc false

  def real_input do
    Utils.get_input(3, 1)
  end

  def sample_input do
    """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
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
    |> Utils.split_lines
    |> Enum.map(&parse_line/1)
    |> list_to_map_by_index
  end

  def list_to_map_by_index(list) do
    list
    |> Enum.with_index
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Map.new
  end

  def array_size(array) do
    {Enum.count(array[0]), Enum.count(array)}
  end

  def parse_line(line) do
    line
    |> Utils.split_each_char
    |> Enum.map(
         fn
           "#" -> 1
           _ -> 0
         end
       )
    |> list_to_map_by_index
  end

  def solve(input) do
    input
    |> count_trees
  end

  def solve2(tree_grid) do
    moves = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    moves
    |> Enum.map(&count_trees(tree_grid, &1))
    |> Enum.reduce(1, fn x, y -> x*y end)
  end

  def count_trees(tree_grid, moves \\ {3, 1}) do
    size = array_size(tree_grid)
    do_count_trees(tree_grid, size, {0, 0}, 0, moves)
  end

  def do_count_trees(tree_grid, {width, height}, {x, y}, count, moves) when y > height do
    count
  end

  def do_count_trees(tree_grid, size = {width, height}, {x, y}, count, moves = {dx, dy}) do
    {nx, ny} = {rem(x + dx, width), y + dy}
    do_count_trees(tree_grid, size, {nx, ny}, count + (tree_grid[ny][nx] || 0), moves)
  end

end
