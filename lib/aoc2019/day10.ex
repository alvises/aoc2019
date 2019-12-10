defmodule Aoc2019.Day10 do
  @type sign :: integer
  @type angle :: float
  @type point :: %{x: integer, y: integer}
  @type asteroid :: point
  @type angle_count :: integer

  @type polar_map :: %{angle => [asteroid]}
  @spec input_to_asteroids(String.t()) :: [asteroid]


  def input_to_asteroids(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({0, []}, fn row, {y, asteroids}->
      {_, asteroids} =
        row
        |> String.to_charlist()
        |> Enum.reduce({0, asteroids}, fn
          ?., {x, asteroids} -> {x + 1, asteroids}
          ?#, {x, asteroids} -> {x + 1, [%{x: x, y: y} | asteroids]}
        end)
      {y + 1, asteroids}
    end)
    |> elem(1)
  end

  @spec get_asteroids_map([asteroid]) :: polar_map
  def get_asteroids_map(asteroids) do
    Enum.reduce(asteroids, %{}, fn a, acc ->
      Enum.reduce(asteroids, acc, fn
        ^a, acc -> acc
        other, acc ->
          # a, other are asteroids (points with x, y coordinates)
          theta = angle(a, other)
          Map.update(acc, a, {1, %{theta => [other]}}, fn {count, angles}->
            if Map.has_key?(angles, theta) do
              {count, Map.update(angles, theta, [other], &([other | &1]))}
            else
              {count + 1, Map.put(angles, theta, [other])}
            end
          end)
      end)
    end)
  end


  # def combine_asteroids(asteroids) do
  #   for a <- asteroids, b <- asteroids, a != b,
  #   do: MapSet.new([a, b]),
  #   into: MapSet.new()
  # end

  @spec angle(point, point) :: angle
  # inverting the angle to have positive angle going "up"
  def angle(a, b), do: :math.atan2(b.y - a.y, b.x - a.x)


  @spec find_asteroid_for_monitoring_station([asteroid]) :: {asteroid, {angle_count, polar_map}}
  def find_asteroid_for_monitoring_station(asteroids) do
    asteroids
    |> get_asteroids_map()
    |> Enum.max_by(fn {_a, {counts, _}} -> counts end)
  end

  def part1(input) do
    {asteroid, {count, _}} =
      input
      |> input_to_asteroids()
      |> find_asteroid_for_monitoring_station()
    {asteroid, count}
  end

  def part2(input, laser_shots) do
    {station, {_, polar_map}} =
      input
      |> input_to_asteroids()
      |> find_asteroid_for_monitoring_station()
    station |> IO.inspect(label: "monitoring station")
    angles = polar_map |> Map.keys() |> Enum.sort()
    idx = Enum.find_index(angles, &(&1 == :math.pi/-2))

    polar_map =
      polar_map
      |> Enum.reduce(%{}, fn {theta, asteroids}, polar_map ->
        Map.put(polar_map, theta, sort_asteroids_by_distance_from_station(asteroids, station))
      end)

    acc = %{idx: idx, angles: angles, vaporized: [], polar_map: polar_map}

    Enum.reduce(1..laser_shots, acc, fn _n, acc ->
      vaporize(acc)
    end)
    |> Map.get(:vaporized)
    # |> IO.inspect(limit: :infinity)
    |> List.first()
  end

  @spec sort_asteroids_by_distance_from_station([asteroid], asteroid) :: [asteroid]
  def sort_asteroids_by_distance_from_station(asteroids, station) do
    Enum.sort_by(asteroids, &manhattan_distance(&1, station), &<=/2)
  end

  def manhattan_distance(a, b) do
    abs(b.y - a.y) + abs(b.x - a.x)
  end

  def vaporize(acc) do
    {angle, acc} = get_next_and_update_idx(acc)
    {asteroid, polar_map} = Map.get_and_update(acc.polar_map, angle, fn
      [a | rest] -> {a, rest}
    end)
    %{acc | vaporized: [asteroid | acc.vaporized], polar_map: polar_map}
  end

  def get_next_and_update_idx(acc) do
    case Enum.at(acc.angles, acc.idx) do
      nil -> get_next_and_update_idx(%{acc | idx: 0})
      angle -> {angle, %{acc | idx: acc.idx + 1}}
    end
  end
end
