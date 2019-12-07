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

  @shortdoc "Runs the day4 part1"
  def run(["day4", "part1"]) do
    Aoc2019.Day4.part1() |> IO.inspect(label: "day4/part1: ")
  end

    @shortdoc "Runs the day4 part1"
  def run(["day4", "part2"]) do
    Aoc2019.Day4.part2() |> IO.inspect(label: "day4/part2: ")
  end

  def run(["day5", "part1"]) do
    File.read!("inputs/day5.txt")
    |> Aoc2019.Day5.run(fn _ -> "1" end)
  end

  def run(["day5", "part2"]) do
    File.read!("inputs/day5.txt")
    |> Aoc2019.Day5.run(fn _ -> "5" end)
  end

  def run(["day6", "part1"]) do
    Aoc2019.Day6.Part1.run() |> IO.inspect(label: "day6/part1: ")
  end

  def run(["day6", "part2"]) do
    File.read!("inputs/day6.txt")
    |> Aoc2019.Day6.Part2.part2()
    |> IO.inspect(label: "day6/part2: ")
  end

  def run(["day7", "part1"]) do
    File.read!("inputs/day7.txt")
    |> Aoc2019.Day7.part1()
    |> IO.inspect(label: "day7/part1: ")
  end

end
