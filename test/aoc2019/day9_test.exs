defmodule Aoc2019.Day9Test do
  use ExUnit.Case
  doctest Aoc2019.Day9
  alias Aoc2019.Day9, as: VM


  describe "relative base" do
    test "initial relative base 2000, with 109,19 instruction the relative becomes 2019" do
      assert VM.input_to_map("109,19")
        |> VM.new_vm()
        |> Map.put(:relative_base, 2000)
        |> VM.process_instruction()
        |> Map.get(:relative_base) == 2019
    end

    test "read value with relative base mode" do
      assert VM.input_to_map("109,19,204,-34")
        |> VM.new_vm()
        |> Map.put(:relative_base, 2000)
        |> VM.process_instruction()
        # putting something in the address 1985
        # which will be read from the next instruction
        |> put_in([:memory, 1985], 123)
        |> VM.process_instruction()
        |> VM.pop_output()
        |> elem(0) == 123
    end
  end
end
