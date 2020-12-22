defmodule Day22 do
  @moduledoc false

  def real_input do
    Utils.get_input(22, 1)
  end

  def sample_input do
    """
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
    """
  end

  def sample_input2 do
    """
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
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
    [[_ | p1], [_ | p2]] = String.split(input, "\n\n") |> Enum.map(&Utils.split_lines/1)
    to_ints = &Enum.map(&1, fn x -> String.to_integer(x) end)
    {to_ints.(p1) |> Qex.new(), to_ints.(p2) |> Qex.new()}
  end

  def play_combat({p1, p2}) do
    case {Qex.first(p1), Qex.first(p2)} do
      {:empty, _} -> p2
      {_, :empty} -> p1
      {v1, v2} -> next_hands(p1, p2) |> play_combat()
    end
  end

  def next_hands(p1, p2) do
    {v1, r1} = Qex.pop!(p1)
    {v2, r2} = Qex.pop!(p2)

    cond do
      v1 > v2 -> {r1 |> Qex.push(v1) |> Qex.push(v2), r2}
      v2 > v1 -> {r1, r2 |> Qex.push(v2) |> Qex.push(v1)}
    end
  end

  def solve(input) do
    input
    |> play_combat()
    |> Enum.to_list()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {x, idx} -> x * (idx + 1) end)
    |> Enum.sum()
  end

  def play_recurisve_combat(players), do: play_recurisve_combat(players, MapSet.new())

  def play_recurisve_combat({p1, p2} = players, table) do
    case MapSet.member?(table, players) do
      false ->
        case {Qex.first(p1), Qex.first(p2)} do
          {:empty, _} ->
            {p1, p2}

          {_, :empty} ->
            {p1, p2}

          _ ->
            new = next_hand_given_winner({p1, p2}, play_round({p1, p2}))
            play_recurisve_combat(new, MapSet.put(table, players))
        end

      true ->
        {p1, Qex.new()}
    end
  end

  def next_hand_given_winner({p1, p2}, winner) do
    {v1, r1} = Qex.pop!(p1)
    {v2, r2} = Qex.pop!(p2)

    case winner do
      true -> {r1 |> Qex.push(v1) |> Qex.push(v2), r2}
      false -> {r1, r2 |> Qex.push(v2) |> Qex.push(v1)}
    end
  end

  def play_round({p1, p2}) do

    case {Qex.first(p1), Qex.first(p2)} do
      {:empty, _} ->
        false

      {_, :empty} ->
        true

      {v1, v2} ->
        {c1, r1} = Qex.pop!(p1)
        {c2, r2} = Qex.pop!(p2)

        cond do
          c1 <= Enum.count(r1) and c2 <= Enum.count(r2) ->
            {s1, _} = Enum.split(r1, c1)
            {s2, _} = Enum.split(r2, c2)
            {n1, n2} = play_recurisve_combat({Qex.new(s1), Qex.new(s2)})

            case {Qex.first(n1), Qex.first(n2)} do
              {:empty, _} -> false
              {_, :empty} -> true
            end

          true ->
            c1 > c2
        end
    end
  end

  def solve2(input) do
    input
    |> play_recurisve_combat()
    |> Tuple.to_list
    |> Enum.reject(&Enum.empty?/1)
    |> hd
    |> Enum.to_list()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {x, idx} -> x * (idx + 1) end)
    |> Enum.sum()
  end
end
