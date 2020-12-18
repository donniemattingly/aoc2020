defmodule Day16 do
  @moduledoc false

  def real_input do
    Utils.get_input(16, 1)
  end

  def sample_input do
    """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """
  end

  def sample_input2 do
    """
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
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
    [categories, my_ticket, nearby_tickets] = input |> String.split("\n\n")

    %{
      categories: parse_categories(categories),
      my: parse_my_ticket(my_ticket),
      nearby: parse_nearby_tickets(nearby_tickets)
    }
  end

  def parse_categories(raw_categories) do
    raw_categories
    |> Utils.split_lines()
    |> Enum.map(&parse_category/1)
  end

  def parse_category(raw_category) do
    r = ~r/([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)/
    [name | bounds] = Regex.run(r, raw_category, capture: :all_but_first)
    [l1, u1, l2, u2] = bounds |> Enum.map(&String.to_integer/1)
    bound1 = Range.new(l1, u1) |> MapSet.new()
    bound2 = Range.new(l2, u2) |> MapSet.new()

    {name, MapSet.union(bound1, bound2)}
  end

  def parse_my_ticket(raw) do
    [_ | [ticket | _]] = Utils.split_lines(raw)
    parse_ticket(ticket)
  end

  def parse_nearby_tickets(raw) do
    [_ | rest] = Utils.split_lines(raw)
    rest |> Enum.map(&parse_ticket/1)
  end

  def parse_ticket(ticket) do
    ticket
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def solve(%{nearby: nearby, categories: categories}) do
    valid_fields =
      categories
      |> Enum.map(&elem(&1, 1))
      |> Enum.reduce(MapSet.new(), fn x, acc -> MapSet.union(x, acc) end)

    nearby
    |> List.flatten()
    |> Enum.filter(fn x -> !MapSet.member?(valid_fields, x) end)
    |> Enum.sum()
  end

  def get_valid_nearby(%{nearby: nearby, categories: categories}) do
    valid_fields =
      categories
      |> Enum.map(&elem(&1, 1))
      |> Enum.reduce(MapSet.new(), fn x, acc -> MapSet.union(x, acc) end)

    nearby
    |> Enum.filter(fn x ->
      Enum.all?(x, &MapSet.member?(valid_fields, &1))
    end)
  end

  def convert_list_of_nearby_tickets_to_position_sets(nearby) do
    nearby
    |> Enum.flat_map(&Enum.with_index/1)
    |> Enum.reduce(%{}, fn {val, idx}, acc ->
      Map.update(acc, idx, MapSet.new([val]), fn cur_set -> MapSet.put(cur_set, val) end)
    end)
    |> Map.to_list()
  end

  def get_categories_for_position(position_sets, categories) do
    position_sets
    |> Enum.map(fn {pos, set} ->
      {pos,
       categories
       |> Enum.filter(fn {_, category_set} -> MapSet.subset?(set, category_set) end)
       |> Enum.map(&elem(&1, 0))
       |> MapSet.new()}
    end)
  end

  def derive_category_for_position(categories_for_positions), do: derive_category_for_position(categories_for_positions, %{})
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

  def add_category_to_ticket(ticket, position_to_category) do
    ticket
    |> Enum.with_index()
    |> Enum.map(fn {val, idx} ->
      {Map.get(position_to_category, idx), val}
    end)
    |> Map.new
  end

  def solve2(input = %{categories: categories, my: my_ticket}) do
    position_to_category = input
    |> get_valid_nearby()
    |> convert_list_of_nearby_tickets_to_position_sets()
    |> get_categories_for_position(categories)
    |> derive_category_for_position()

    add_category_to_ticket(my_ticket, position_to_category)
    |> Map.to_list
    |> Enum.filter(fn {name, _} -> String.starts_with?(name, "departure") end)
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.reduce(1, &Kernel.*/2)
  end
end
