defmodule Aoc2019.Day3Test do
  use ExUnit.Case
  doctest Aoc2019.Day3

  alias Aoc2019.Day3, as: Wires


  describe "moves/1" do
    test "transforms the input string in a list of moves" do
      assert Wires.moves("R8,U5,L5,D3") == [{:r, 8}, {:u, 5}, {:l, 5}, {:d, 3}]
    end
  end


  describe "wire/1" do
    test "transforms the moves into a wire" do
      assert Wires.wire( [{:r, 8}, {:u, 5}, {:l, 5}, {:d, 3}]) == Enum.reverse([
        {0, 0},
        {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}, {7, 0}, {8, 0},
        {8, 1}, {8, 2}, {8, 3}, {8, 4}, {8, 5},
        {7, 5}, {6, 5}, {5, 5}, {4, 5}, {3, 5},
        {3, 4}, {3, 3}, {3, 2},
      ])
    end
  end

  describe "add_points/2" do
    test "return a list of points" do
      assert Wires.add_points({:r, 2}, [{0,0}]) == [{2, 0}, {1, 0}, {0, 0}]
    end

    test "adds new point to the existing list starting from the point at the head" do
      assert Wires.add_points({:u, 2}, [{2, 0}, {1, 0}, {0, 0}]) ==
            [{2, 2}, {2, 1}, {2, 0}, {1, 0}, {0, 0}]
    end
  end

  test "part1" do
    assert Wires.part1("""
    R8,U5,L5,D3
    U7,R6,D4,L4
    """) == {6, {3, 3}}
  end


  test "part2" do
    assert Wires.part2("""
    R8,U5,L5,D3
    U7,R6,D4,L4
    """) == 30
  end

end
