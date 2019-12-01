defmodule Mix.Tasks.Aoc2019 do
  use Mix.Task

  @shortdoc "Runs the day1 part1"
  def run(["day1", "part1"]) do
    Aoc2019.Day1.part1() |> IO.inspect(label: "day1/part1: ")
  end

  @shortdoc "Runs the day1 part2"
  def run(["day1", "part2"]) do
    Aoc2019.Day1.part2() |> IO.inspect(label: "day1/part2: ")
  end

end
