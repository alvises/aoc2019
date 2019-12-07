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

    describe "process_signal" do
      test "4,3,2,1,0 phase outputs 43210" do
        memory = VM.input_to_map("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
        amplifiers =
          Enum.map([4,3,2,1,0], fn phase ->
            VM.new_vm(memory, [phase])
          end)

        assert {_, 43210} = VM.process_signal(amplifiers, 0)
      end
    end

    describe "part1" do
      test "finds the phase that maximizes the output" do
        assert 43210 ==
          "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
          |> VM.part1()
      end
    end

    describe "permutations" do
      test "permutations of [1,2,3]" do
        assert VM.permutations([1,2,3])|> MapSet.new() == MapSet.new([
          [1,2,3],
          [1,3,2],
          [2,1,3],
          [2,3,1],
          [3,1,2],
          [3,2,1]
        ])
      end
    end

    test "run_feedback_loop" do
      assert 139629729 ==
        "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
        |> VM.input_to_map()
        |> VM.new_system([9,8,7,6,5])
        |> VM.run_feedback_loop(0)
      assert 18216 ==
        "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
        |> VM.input_to_map()
        |> VM.new_system([9,7,8,5,6])
        |> VM.run_feedback_loop(0)
    end

    test "part2" do
      assert 18216 == "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
      |> VM.part2()

    end
end
