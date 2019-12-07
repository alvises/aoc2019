defmodule Aoc2019.Day7Test do
  use ExUnit.Case
  doctest Aoc2019.Day7
  alias Aoc2019.Day7, as: VM


  test "sets 3500 at address 0 and 70 in 3" do
    vm =
      VM.to_map([1,9,10,3,2,3,11,0,99,30,40,50])
      |> VM.new_vm([123])
      |> VM.run()
      # memory [3500,9,10,70,2,3,11,0,99,30,40,50]

    assert Map.take(vm.memory,[0,3]) == %{
      0 => 3500,
      3 => 70
    }
  end

  test "output 999 if the input value is below 8 (7 in this case)" do
    vm =
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
      |> VM.input_to_map()
      |> VM.new_vm([7])
      |> VM.run()

    assert vm.output == [999]
  end

  test "if input is 1, outputs 1 (with immediate mode)" do
    vm =
      "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
      |> VM.input_to_map()
      |> VM.new_vm([1])
      |> VM.run()

    assert vm.output == [1]
  end


    test "if input is 0, outputs 0 (with position mode)" do
      vm =
        "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
        |> VM.input_to_map()
        |> VM.new_vm([0])
        |> VM.run()

        assert vm.output == [0]
    end

    test "if input is 1, outputs 1 (with position mode)" do
      vm =
        "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
        |> VM.input_to_map()
        |> VM.new_vm([1])
        |> VM.run()

        assert vm.output == [1]
    end

    test "if input is 0, outputs 0 (with immediate mode)" do
      vm =
        "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
        |> VM.input_to_map()
        |> VM.new_vm([0])
        |> VM.run()

      assert vm.output == [0]
    end

    test "part1 with input and print" do
      vm =
        "3,0,4,0,99"
        |> VM.input_to_map()
        |> VM.new_vm([123])
        |> VM.run()
      assert vm.output == [123]
    end

    test "prints 1 when input is 8, 0 otherwise" do
      vm =
        "3,9,8,9,10,9,4,9,99,-1,8"
        |> VM.input_to_map()
        |> VM.new_vm([8])
        |> VM.run()
      assert vm.output == [1]

      vm =
        "3,9,8,9,10,9,4,9,99,-1,8"
        |> VM.input_to_map()
        |> VM.new_vm([123])
        |> VM.run()
      assert vm.output == [0]
    end

end
