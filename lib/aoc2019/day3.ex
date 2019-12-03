defmodule Aoc2019.Day3 do
  @type point :: {integer, integer}
  @type wire :: [point]
  @type move :: {:r | :d | :u | :l, integer}

  @spec moves(String.t()) :: [move]
  def moves(input_line) do
    input_line
    |> String.split(",")
    |> Enum.map(fn
      "R" <> num -> {:r, String.to_integer(num)}
      "D" <> num -> {:d, String.to_integer(num)}
      "L" <> num -> {:l, String.to_integer(num)}
      "U" <> num -> {:u, String.to_integer(num)}
    end)
  end

  @spec wire([move]) :: wire
  def wire(moves) do
    Enum.reduce(moves, [{0, 0}], &add_points/2)
  end

  @doc """
  Given a move, adds the points to the list
  """
  @spec add_points(move, [point]) :: [point]
  def add_points({_, 0}, points), do: points
  def add_points({direction, steps}=move, [prev_point | _]=acc) do
    add_points({direction, steps - 1}, [next_point(move, prev_point) | acc])
  end

  @spec next_point(move, point) :: point
  defp next_point({:r, _}, {x, y}), do: {x + 1, y}
  defp next_point({:d, _}, {x, y}), do: {x, y - 1}
  defp next_point({:l, _}, {x, y}), do: {x - 1, y}
  defp next_point({:u, _}, {x, y}), do: {x, y + 1}


  def part1(input) do
    input
    |> String.split()
    |> Enum.map(&(moves(&1) |> wire() |> MapSet.new()))
    |> case do
      [wire1, wire2] -> MapSet.intersection(wire1, wire2)
    end
    |> MapSet.delete({0, 0})
    |> Enum.map(fn {x, y} -> {abs(x) + abs(y), {x, y}} end)
    |> Enum.min()
  end

  def part1, do: File.read!("inputs/day3.txt") |> part1()


  def part2(input) do
    [wire1, wire2] =
      input
      |> String.split()
      |> Enum.map(fn input_line ->
        input_line
        |> moves()
        |> wire()
        |> Enum.reverse()
      end)

    #intersection
    MapSet.intersection(MapSet.new(wire1), MapSet.new(wire2))
    #remove origin
    |> MapSet.delete({0, 0})

    #calculate the total number of steps
    |> Enum.map(fn intersection ->
      # +2 because find_index is 0 indexed
      Enum.find_index(wire1, &(&1 == intersection)) +
      Enum.find_index(wire2, &(&1 == intersection))
    end)
    |> Enum.min()
  end

  def part2, do: File.read!("inputs/day3.txt") |> part2()
end
