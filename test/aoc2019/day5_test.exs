defmodule Aoc2019.Day5Test do
  use ExUnit.Case
  doctest Aoc2019.Day5
  import ExUnit.CaptureIO, only: [capture_io: 1]
  alias Aoc2019.Day5, as: VM

  test "part1 with input and print" do
    assert capture_io(fn ->
      VM.part1("3,0,4,0,99", fn _-> "123" end)
    end) == "123\n"
  end

  describe "part2" do
    test "take an input, then output 0 if the input was zero" do

    end
    # "3, 12, 6,12,15,1,13,14,13,4,13,99,0,0,1,9", 2) |> process_instruction()
  end
end
