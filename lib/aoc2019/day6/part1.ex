defmodule Aoc2019.Day6.Part1 do
  @type obj :: String.t()
  @type orbit :: %{o: String.t(), dist: integer}
  @type orbits :: %{obj => orbit}

  @spec to_map(String.t()) :: orbits
  def to_map(input) do
    direct_orbits = get_direct_orbits(input)
    Enum.reduce(direct_orbits, %{}, fn {right, left}, orbits ->
      if Map.has_key?(orbits, right), do: orbits,
      else: add_orbit(orbits, left, right, direct_orbits)
    end)
  end

  @doc """
  Get a map of direct orbits
  """
  @spec get_direct_orbits(String.t()) :: %{obj => obj}
  def get_direct_orbits(input) do
    for line <- String.split(input),
    do: String.split(line,")", trim: true) |> Enum.reverse() |> List.to_tuple(),
    into: %{}
  end

  @doc """
  `right` object orbits around the `left` object
  """
  @spec add_orbit(orbits, obj, obj, %{obj => obj}) :: orbits
  def add_orbit(orbits, "COM", right, _) do
    Map.put(orbits, right, %{o: "COM", dist: 1})
  end

  def add_orbit(orbits, left, right, direct_orbits) do
    case Map.get(orbits, left) do
      %{dist: distance} -> Map.put(orbits, right, %{o: left, dist: distance + 1})
      nil ->
        add_orbit(orbits, Map.get(direct_orbits, left), left, direct_orbits)
        |> add_orbit(left, right, direct_orbits)
    end

  end

  @doc """
  Calculates the total number of orbits
  """
  def orbits_count(orbits) do
    orbits
    |> Enum.map(fn {_obj, orbit} -> orbit.dist end)
    |> Enum.sum()
  end


  def run(input) do
    input
    |> to_map()
    |> orbits_count()
  end

  def run do
    File.read!("inputs/day6.txt") |> run()
  end
end
