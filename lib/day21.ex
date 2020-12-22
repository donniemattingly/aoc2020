defmodule Day21 do
  @moduledoc false

  def real_input do
    Utils.get_input(21, 1)
  end

  def sample_input do
    """
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
    """
  end

  def sample_input2 do
    """
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
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
    [raw_ingredients, raw_allergens] = String.split(line, "(contains")
    ingredients = String.split(raw_ingredients)
    allergens = String.split(raw_allergens) |> Enum.map(&String.replace(&1, ~r/[\,\)]/, ""))
    {allergens, ingredients}
  end

  def expand_allergens({allergens, ingredients}) do
    allergens
    |> Enum.map(fn a -> {a, ingredients} end)
  end

  def solve(input) do
    known_allergens =
      input
      |> Enum.flat_map(&expand_allergens/1)
      |> Enum.reduce(%{}, fn {a, ingredients}, acc ->
        Map.update(acc, a, MapSet.new(ingredients), fn i ->
          MapSet.intersection(i, MapSet.new(ingredients))
        end)
      end)
      |> Map.values()
      |> Enum.reduce(MapSet.new(), &MapSet.union/2)

    all_ingredients =
      input
      |> Enum.flat_map(&elem(&1, 1))

    known_not_allergens = all_ingredients |> MapSet.new() |> MapSet.difference(known_allergens)

    freqs = Enum.frequencies(all_ingredients)

    known_not_allergens
    |> Enum.map(fn x -> freqs[x] end)
    |> Enum.sum()
  end

  def solve2(input) do
      input
      |> Enum.flat_map(&expand_allergens/1)
      |> Enum.reduce(%{}, fn {a, ingredients}, acc ->
        Map.update(acc, a, MapSet.new(ingredients), fn i ->
          MapSet.intersection(i, MapSet.new(ingredients))
        end)
      end)
      |> derive_category_for_position()
      |> Map.to_list
      |> Enum.sort(fn x, y -> elem(x, 0) < elem(y, 0) end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.join(",")
  end

  def derive_category_for_position(categories_for_positions),
    do: derive_category_for_position(categories_for_positions, %{})

  def derive_category_for_position([], confirmed), do: confirmed

  def derive_category_for_position(position_categories, confirmed) do
    # get pos->category with the smallest size (1)
    [{pos, categories} | rest] =
      position_categories
      |> Enum.sort(&(MapSet.size(elem(&1, 1)) < MapSet.size(elem(&2, 1))))

    # add this category to the confirmed map
    category = MapSet.to_list(categories) |> hd
    new_confirmed = Map.put(confirmed, pos, category)

    # update the rest of the list removing the category we used
    updated_remaining =
      rest
      |> Enum.map(fn {pos, categories} -> {pos, MapSet.delete(categories, category)} end)
      |> Enum.filter(fn
        [] -> false
        _ -> true
      end)

    # recurse recurse
    derive_category_for_position(updated_remaining, new_confirmed)
  end
end
