defmodule Aoc2019.Day5Test do
  use ExUnit.Case
  doctest Aoc2019.Day5
  import ExUnit.CaptureIO, only: [capture_io: 1]
  alias Aoc2019.Day5, as: VM

  test "part1 with input and print" do
    assert capture_io(fn ->
      VM.run("3,0,4,0,99", fn _-> "123" end)
    end) == "123\n"
  end

  describe "part2" do
    test "prints 1 when input is 8, 0 otherwise" do
      assert capture_io(fn ->
        VM.run("3,9,8,9,10,9,4,9,99,-1,8", fn _-> "8" end)
      end) == "1\n"

      assert capture_io(fn ->
        VM.run("3,9,8,9,10,9,4,9,99,-1,8", fn _-> "123" end)
      end) == "0\n"

    end

    test "if input is 0, outputs 0 (with position mode)" do
      assert capture_io(fn ->
        "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
        |> VM.run(fn _ -> "0" end)
      end) == "0\n"
    end

    test "if input is 1, outputs 1 (with position mode)" do
      assert capture_io(fn ->
        "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
        |> VM.run(fn _ -> "1" end)
      end) == "1\n"
    end

    test "if input is 0, outputs 0 (with immediate mode)" do
      assert capture_io(fn ->
        "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
        |> VM.run(fn _ -> "0" end)
      end) == "0\n"
    end

    test "if input is 1, outputs 1 (with immediate mode)" do
      assert capture_io(fn ->
        "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
        |> VM.run(fn _ -> "1" end)
      end) == "1\n"
    end

    test "output 999 if the input value is below 8" do
      assert capture_io(fn ->
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
        |> VM.run(fn _ -> "7" end)
      end) == "999\n"
    end

  end
end
