defmodule Aoc2019.Day6.Part2 do
  @moduledoc """
                            YOU
                          /
          G - H       J - K - L
        /            /
  COM - B - C - D - E - F
                \
                  I - SAN


  We treet the objects and orbits as a graph
  """
  alias Aoc2019.Day6.Part1, as: Orbits

  @type vertex :: String.t()
  @type neighbors :: MapSet.t(vertex)
  @type graph :: %{vertex => neighbors}

  @doc """
  Given the direct orbits of the challenge, it builds a graph
  represented by a map where all the objects are verteces (keys) and
  the values are neighbors

    ## Examples
      iex> Aoc2019.Day6.Part2.build_graph(%{
      ...>  "B" => "COM",
      ...>  "C" => "B",
      ...>  "D" => "C",
      ...>  "E" => "D",
      ...>  "F" => "E",
      ...>  "G" => "B",
      ...>  "H" => "G",
      ...>  "I" => "D",
      ...>  "J" => "E",
      ...>  "K" => "J",
      ...>  "L" => "K",
      ...>  "YOU" => "K",
      ...>  "SAN" => "I"
      ...> })
      %{
        "COM" => MapSet.new(["B"]),
        "B" => MapSet.new(["COM", "G", "C"]),
        "G" => MapSet.new(["H", "B"]),
        "H" => MapSet.new(["G"]),
        "C" => MapSet.new(["B", "D"]),
        "D" => MapSet.new(["C", "E", "I"]),
        "E" => MapSet.new(["D", "J", "F"]),
        "F" => MapSet.new(["E"]),
        "I" => MapSet.new(["D", "SAN"]),
        "J" => MapSet.new(["E", "K"]),
        "K" => MapSet.new(["J", "YOU", "L"]),
        "L" => MapSet.new(["K"]),
        "SAN" => MapSet.new(["I"]),
        "YOU" => MapSet.new(["K"]),
      }

  """
  @spec build_graph(%{String.t() => String.t()}) :: graph
  def build_graph(direct_orbits) do
    direct_orbits
    |> Stream.flat_map(fn {k, v}-> [{k, v}, {v, k}] end)
    |> Enum.reduce(%{}, fn {vertex, neighbor}, graph ->
      Map.update(graph, vertex, MapSet.new([neighbor]), &MapSet.put(&1, neighbor))
    end)
  end

  @doc """
  Finds the minimum path between to vertices.
  It returns `{distance, [vertex]}` when the path is found
  `{nil, _}` when is not found (this case is useful in subpaths)

    ## Examples
      iex> graph = %{
      ...>  "COM" => MapSet.new(["B"]),
      ...>  "B" => MapSet.new(["COM", "G", "C"]),
      ...>  "G" => MapSet.new(["H", "B"]),
      ...>  "H" => MapSet.new(["G"]),
      ...>  "C" => MapSet.new(["B", "D"]),
      ...>  "D" => MapSet.new(["C", "E", "I"]),
      ...>  "E" => MapSet.new(["D", "J", "F"]),
      ...>  "F" => MapSet.new(["E"]),
      ...>  "I" => MapSet.new(["D", "SAN"]),
      ...>  "J" => MapSet.new(["E", "K"]),
      ...>  "K" => MapSet.new(["J", "YOU", "L"]),
      ...>  "L" => MapSet.new(["K"]),
      ...>  "SAN" => MapSet.new(["I"]),
      ...>  "YOU" => MapSet.new(["K"]),
      ...>}
      iex> Aoc2019.Day6.Part2.find_min_path(graph, "C", "E", {0, ["C"]})
      {3, ["E", "D", "C"]}
      iex> Aoc2019.Day6.Part2.find_min_path(graph, "YOU", "SAN", {0, ["YOU"]})
      {7, ["SAN", "I", "D", "E", "J", "K", "YOU"]}

  """
  @spec find_min_path(graph, vertex, vertex, {integer, [vertex]}) :: {:not_found | integer, [vertex]}
  def find_min_path(_, dst, dst, {steps, path}), do: {steps + 1, path}
  def find_min_path(graph, src, dst, {steps, path}) do
    # neighbors to visit
    neighbors = get_uncharted_neighbors(graph, src, path)

    # calculate the best path for each neighbor
    paths = Enum.map(neighbors, fn n -> find_min_path(graph, n, dst, {steps + 1, [n | path]}) end)

    # choose the shortest one
    case paths do
      [] -> {:not_found, path}
      paths -> min_path(paths)
    end
  end

  def get_uncharted_neighbors(graph, src, path) do
    # getting the vertex neighbors from the graph
    Map.get(graph, src)
    # removing the vertices already visited
    |> MapSet.difference(MapSet.new(path))
  end

  @doc """
  Min path between paths passed
  """
  @spec min_path([{:not_found | integer, [vertex]}]) :: {:integer , [vertex]} | nil
  def min_path(paths) do
    paths
    |> Enum.filter(&match?({steps, _} when steps != :not_found, &1))
    |> Enum.min_by(&elem(&1, 0), fn -> :not_found end)
  end

  @doc """
  Finds the best path with the number of verteces considering src and dst

    ## Example
    iex> Aoc2019.Day6.Part2.run(
    ...> "COM)B
    ...> B)C
    ...> C)D
    ...> D)E
    ...> E)F
    ...> B)G
    ...> G)H
    ...> D)I
    ...> E)J
    ...> J)K
    ...> K)L
    ...> K)YOU
    ...> I)SAN")
    {7,["SAN", "I", "D", "E", "J", "K", "YOU"]}
  """
  def run(input) do
    input
    |> Orbits.get_direct_orbits()
    |> build_graph()
    |> find_min_path("YOU", "SAN", {0, ["YOU"]})
  end



  @doc """
  Solves the Day6 part2, returning the number of transitions needed, which is
  the number of steps - 2 verteces (src and dst) - 1

    ## Example
    iex> Aoc2019.Day6.Part2.part2(
    ...> "COM)B
    ...> B)C
    ...> C)D
    ...> D)E
    ...> E)F
    ...> B)G
    ...> G)H
    ...> D)I
    ...> E)J
    ...> J)K
    ...> K)L
    ...> K)YOU
    ...> I)SAN")
    4
  """

  def part2(input) do
    {steps, _} = run(input)
    steps - 3
  end
end
