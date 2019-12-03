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


  @shortdoc "Runs the day2 part1"
  def run(["day2", "part1"]) do
    Aoc2019.Day2.part1() |> IO.inspect(label: "day2/part1: ")
  end

  @shortdoc "Runs the day2 part2"
  def run(["day2", "part2"]) do
    Aoc2019.Day2.part2() |> IO.inspect(label: "day2/part2: ")
  end

  @shortdoc "Runs the day3 part1"
  def run(["day3", "part1"]) do
    Aoc2019.Day3.part1() |> IO.inspect(label: "day3/part1: ")
  end

  @shortdoc "Runs the day3 part2"
  def run(["day3", "part2"]) do
    Aoc2019.Day3.part2() |> IO.inspect(label: "day3/part2: ")
  end

end
