defmodule Aoc2019.Day1 do
  @type mass :: integer

  @doc """
  Gets the `fuel` needed to launch the given module's `mass`.

    ## Examples
      iex> Aoc2019.Day1.fuel(12)
      2
      iex> Aoc2019.Day1.fuel(14)
      2
      iex> Aoc2019.Day1.fuel(1969)
      654
      iex> Aoc2019.Day1.fuel(100756)
      33583
  """
  @spec fuel(mass) :: integer
  def fuel(mass) do
    mass
    |> div(3)
    |> floor()
    |> Kernel.-(2)
  end

  @doc """
  Calculates the total fuel requirement for the list of masses

    ## Examples
    iex> Aoc2019.Day1.total_fuel([12, 14, 1969, 100756])
    2 + 2 + 654 + 33583

  """
  @spec total_fuel([mass]) :: integer
  def total_fuel(masses) do
    masses
    |> Enum.map(&fuel/1)
    |> Enum.sum()
  end

  def part1() do
    File.read!("inputs/day1.txt")
    |> part1()
  end

  @doc """
  Gets the total fuel of the masses in the given input string

    ## Examples
    iex> Aoc2019.Day1.part1("12\\n14\\n1969\\n100756\\n")
    2 + 2 + 654 + 33583

  """
  @spec part1(String.t()) :: integer
  def part1(input) do
    input
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> total_fuel()
  end


  def part2() do
    File.read!("inputs/day1.txt")
    |> part2()
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&fuel_for_module_and_fuel_mass/1)
    |> Enum.sum()
  end

  @doc """
  Calculates the fuel needed for the fuel mass and returns
  the total fuel.

    ## Examples
      iex> Aoc2019.Day1.fuel_for_module_and_fuel_mass(14)
      2

      iex> Aoc2019.Day1.fuel_for_module_and_fuel_mass(1969)
      966

      iex> Aoc2019.Day1.fuel_for_module_and_fuel_mass(100756)
      50346

  """
  @spec fuel_for_module_and_fuel_mass(mass) :: integer
  def fuel_for_module_and_fuel_mass(mass) do
    case fuel(mass) do
      fuel when fuel > 0 ->
        fuel + fuel_for_module_and_fuel_mass(fuel)
      _ -> 0
    end
  end

end
