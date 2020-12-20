defmodule Day19 do
  @moduledoc false
  use Combine

  def real_input do
    Utils.get_input(19, 1)
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

  def sample_input do
    """
    42: 9 14 | 10 1
    9: 14 27 | 1 26
    10: 23 14 | 28 1
    1: "a"
    11: 42 31
    5: 1 14 | 15 1
    19: 14 1 | 14 14
    12: 24 14 | 19 1
    16: 15 1 | 14 14
    31: 14 17 | 1 13
    6: 14 14 | 1 14
    2: 1 24 | 14 4
    0: 8 11
    13: 14 3 | 1 12
    15: 1 | 14
    17: 14 2 | 1 7
    23: 25 1 | 22 14
    28: 16 1
    4: 1 1
    20: 14 14 | 1 15
    3: 5 14 | 16 1
    27: 1 6 | 14 18
    14: "b"
    21: 14 1 | 1 14
    25: 1 1 | 1 14
    22: 14 14
    8: 42
    26: 14 22 | 1 20
    18: 15 15
    7: 14 5 | 1 21
    24: 14 1

    abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
    bbabbbbaabaabba
    babbbbaabbbbbabbbbbbaabaaabaaa
    aaabbbbbbaaaabaababaabababbabaaabbababababaaa
    bbbbbbbaaaabbbbaaabbabaaa
    bbbababbbbaaaaaaaabbababaaababaabab
    ababaaaaaabaaab
    ababaaaaabbbaba
    baabbaaaabbaaaababbaababb
    abbbbabbbbaaaababbbbbbaaaababb
    aaaaabbaabaaaaababaa
    aaaabbaaaabbaaa
    aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
    babaaabbbaaabaababbaabababaaab
    aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
    """
  end

  def parse_input(input) do
    [rules, messsages] = input |> String.split("\n\n")
    {parse_rules(rules), parse_messages(messsages)}
  end

  def parse_messages(raw_messages), do: Utils.split_lines(raw_messages)

  def parse_rules(raw_rules) do
    raw_rules
    |> Utils.split_lines()
    |> Enum.map(&parse_rule/1)
  end

  def parse_rule(raw_rule) do
    [name, rule] = raw_rule |> String.replace("\"", "") |> String.split(":")

    rule_components =
      String.split(rule, "|")
      |> Enum.map(&String.split/1)

    {name, rule_components}
  end

  def resolve_rules(rules) do
    resolved_map = generate_seed_map(rules)
    unresolved_rules = rules |> Enum.reject(fn {name, _} -> Map.has_key?(resolved_map, name) end)
    resolve_rules(unresolved_rules, resolved_map)
  end

  def generate_seed_map(rules) do
    rules
    |> Enum.filter(fn
      {_, [[rule]]} -> rule == "a" || rule == "b"
      _ -> false
    end)
    |> Enum.map(fn {name, [[letter]]} -> {name, char(letter) |> label(name)} end)
    |> Map.new()
  end

  def resolve_rules([], map), do: map

  def generate_num_11(p42, p31) do
    1..100
    |> Enum.map(fn i ->
      ((1..i |> Enum.map(fn _ -> p42 end)) ++ (1..i |> Enum.map(fn _ -> p31 end))) |> sequence()
    end)
    |> choice()
  end

  def resolve_rules(rules, resolved_map) do
    res =
      Enum.find(
        rules,
        fn {_, components} ->
          components
          |> List.flatten()
          |> Enum.map(&Map.has_key?(resolved_map, &1))
          |> Enum.all?(& &1)
        end
      )

    {name, components} = res

    rest = Enum.reject(rules, fn rule -> rule == {name, components} end)

    parser =
      components
      |> Enum.map(fn component -> component |> Enum.map(&Map.get(resolved_map, &1)) end)
      |> Enum.map(&sequence/1)
      |> choice()
      |> label(name)

    resolve_rules(rest, Map.put(resolved_map, name, parser))
  end

  def gen_rule_variants(resolved_rules) do

  end

  def solve(input) do
    {unresolved_rules, messages} = input
    rules = resolve_rules(unresolved_rules)

    messages
    |> Enum.map(&Combine.parse(&1, rules["0"] |> eof()))
    |> Enum.reject(fn
      {:error, _} -> true
      _ -> false
    end)
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&Enum.join/1)
  end
end
