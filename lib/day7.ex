defmodule Day7 do
  @moduledoc false

  def real_input do
    Utils.get_input(7, 1)
  end

  def sample_input do
    """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """
  end

  def sample_input2 do
    """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
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
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [bag, contents] = String.split(line, " contain ")

    parsed_contents =
      String.split(contents, ", ")
      |> Enum.map(&parse_bag_description/1)

    parsed_bag = String.replace(bag, " bags", "")

    [parsed_bag, parsed_contents]
  end

  def parse_bag_description("no other bags."), do: [0, nil]

  def parse_bag_description(desc) do
    cleaned =
      desc
      |> String.replace(" bags.", "")
      |> String.replace(" bags", "")
      |> String.replace(" bag.", "")
      |> String.replace(" bag", "")

    [num, type] = Regex.run(~r/(\d+) ([\w\s]+)/, cleaned, capture: :all_but_first)

    [String.to_integer(num), type]
  end

  def get_contains_map(parsed) do
    parsed
    |> Enum.flat_map(fn [bag, contents] ->
      Enum.map(contents, fn [_, type] -> [type, bag] end)
    end)
    |> Enum.reduce(
      %{},
      fn [type, bag], acc ->
        Map.update(acc, type, [bag], fn l -> [bag | l] end)
      end
    )
  end

  def get_contains_map2(parsed) do
    parsed
    |> Enum.flat_map(fn [bag, contents] ->
      Enum.map(contents, fn [count, type] -> [{type, count}, bag] end)
    end)
    |> Enum.reduce(
      %{},
      fn [type, bag], acc ->
        Map.update(acc, bag, [type], fn l -> [type | l] end)
      end
    )
  end

  def get_bags_that_could_contain(bag_map, type) do
    case Map.get(bag_map, type) do
      nil -> type
      l -> [type | Enum.map(l, &get_bags_that_could_contain(bag_map, &1)) |> Utils.List.flatten()]
    end
  end

  def solve(input) do
    input
    |> get_contains_map()
    |> get_bags_that_could_contain("shiny gold")
    |> IO.inspect()
    |> MapSet.new()
    |> MapSet.size()
  end

  def get_bags_contained_within(bag_map, bag, num \\ 1) do
    IO.inspect(bag)

    case Map.get(bag_map, bag) do
      [{nil, 0}] ->
        0

      l ->
        l
        |> Enum.map(fn {type, count} ->
          count * get_bags_contained_within(bag_map, type, num)
        end)
        |> Enum.sum()
    end + num
  end

  def solve2(input) do
    input
    |> get_contains_map2()
    |> get_bags_contained_within("shiny gold")
    |> Kernel.-(1)
  end

  def get_color_options() do
    Day7.real_input()
    |> Day7.parse_input()
    |> Utils.List.flatten()
    |> Enum.uniq()
    |> Enum.reject(&is_number/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&String.split/1)
  end
end
