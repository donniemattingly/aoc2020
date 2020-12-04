defmodule Day4 do
  @moduledoc false

  def real_input do
    Utils.get_input(4, 1)
  end

  def sample_input do
    """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """
  end

  def sample_input2 do
    """
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    """
  end

  def sample_input3 do
    """
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    """
  end

  def required_fields do
    [
      :byr,
      :iyr,
      :eyr,
      :hgt,
      :hcl,
      :ecl,
      :pid,
    ]
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

  def parse_and_solve1(input),
      do: parse_input1(input)
          |> solve1
  def parse_and_solve2(input),
      do: parse_input2(input)
          |> solve2

  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_passport/1)
  end

  def parse_passport(passport) do
    passport
    |> String.split()
    |> Enum.map(&parse_field/1)
    |> Map.new
  end

  def parse_field(field) do
    [name, value] = field
                    |> String.split(":")
    {String.to_atom(name), value}
  end

  def is_passport_valid?(passport) do
    required_fields
    |> Enum.all?(&Map.has_key?(passport, &1))
  end

  def is_passport_valid2?(passport) do
    has_required_fields = required_fields |> Enum.all?(&Map.has_key?(passport, &1))
    all_fields_valid = Map.to_list(passport) |> Enum.all?(&is_field_valid?/1)

#    IO.inspect({passport, has_required_fields and all_fields_valid})
#    Map.to_list(passport) |> Enum.map(fn x -> {x, is_field_valid?(x)} end) |> IO.inspect

    has_required_fields and all_fields_valid
  end

  def string_num_between(string, min, max) do
    num = String.to_integer(string)
    min <= num and num <= max
  end

  def is_field_valid?({:byr, value}) do
    string_num_between(value, 1920, 2020)
  end

  def is_field_valid?({:iyr, value}) do
    string_num_between(value, 2010, 2020)
  end

  def is_field_valid?({:eyr, value}) do
    string_num_between(value, 2020, 2030)
  end

  def is_field_valid?({:hgt, value}) do
    case String.split_at(value, -2) do
      {num, "in"} -> string_num_between(num, 59, 76)
      {num, "cm"} -> string_num_between(num, 150, 193)
      _ -> false
    end
  end

  def is_field_valid?({:hcl, "#" <> hex}) do
    case Integer.parse(hex, 16) do
      :error -> false
      {_num, _} -> true
    end
  end

  def is_field_valid?({:ecl, value}) do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], value)
  end

  def is_field_valid?({:pid, value}) do
    case String.length(value) do
      9 -> Integer.parse(value) != :error
      _ -> false
    end
  end

  def is_field_valid?({:cid, _}), do: true
  def is_field_valid?(_), do: false


  def solve(input) do
    input
    |> Enum.count(&is_passport_valid?/1)
  end

  def solve2 (input) do
    input
    |> Enum.count(&is_passport_valid2?/1)
  end

end
