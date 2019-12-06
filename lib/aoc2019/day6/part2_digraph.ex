defmodule Aoc2019.Day6.Part2.Digraph do
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


  def build_graph(direct_orbits) do
    direct_orbits
    |> Stream.flat_map(fn {k, v}-> [{k, v}, {v, k}] end)
    |> Enum.reduce(:digraph.new(), fn {vertex, neighbor}, graph ->
      :digraph.add_vertex(graph, vertex)
      :digraph.add_vertex(graph, neighbor)
      :digraph.add_edge(graph, vertex, neighbor)
      :digraph.add_edge(graph, neighbor, vertex)
      graph
    end)
  end



  def min_path(input) do
    input
    |> Orbits.get_direct_orbits()
    |> build_graph()
    |> :digraph.get_short_path("YOU", "SAN")
  end



  @doc """
  Solves the Day6 part2, returning the number of transitions needed, which is
  the number of steps - 2 verteces (src and dst) - 1

    ## Example
    iex> Aoc2019.Day6.Part2.Digraph.part2(
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
    min_path(input) |> Enum.count() |> Kernel.-(3)
  end
end
