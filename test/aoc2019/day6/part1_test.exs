defmodule Aoc2019.Day6.Part1Test do
  use ExUnit.Case
  doctest Aoc2019.Day6.Part1
  alias Aoc2019.Day6.Part1, as: Orbits

  test "get_direct_orbits/1" do
    assert """
    COM)B
    B)C
    C)D
    D)E
    """ |> Orbits.get_direct_orbits() == %{
      "B" => "COM", "C" => "B", "D" => "C", "E" => "D"
    }
  end

  describe "add_orbit" do
    test "add without need of solving dependenies" do
      assert Orbits.add_orbit(%{},"COM", "A", %{}) == %{"A" => %{o: "COM", dist: 1}}

      assert Orbits.add_orbit(%{},"COM", "A", %{}) |> Orbits.add_orbit("A", "B", %{}) == %{
        "A" => %{o: "COM", dist: 1},
        "B" => %{o: "A", dist: 2}
      }
    end

    test "solves dependencies using direct_orbits map" do
      direct_orbits = %{"B" => "COM", "D" => "C", "E" => "D", "C" => "B"}
      assert Orbits.add_orbit(%{},"C", "D", direct_orbits) == %{
        "B" => %{o: "COM", dist: 1},
        "C" => %{o: "B", dist: 2},
        "D" => %{o: "C", dist: 3}
      }
    end

  end

  describe "to_map/1" do
    test "converts input into a map of orbits with the distance" do
      assert """
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
      """
      |> Orbits.to_map() == %{
        "B" => %{o: "COM", dist: 1},
        "C" => %{o: "B", dist: 2},
        "D" => %{o: "C", dist: 3},
        "E" => %{o: "D", dist: 4},
        "F" => %{o: "E", dist: 5},
        "G" => %{o: "B", dist: 2},
        "H" => %{o: "G", dist: 3},
        "I" => %{o: "D", dist: 4},
        "J" => %{o: "E", dist: 5},
        "K" => %{o: "J", dist: 6},
        "L" => %{o: "K", dist: 7}
      }
    end

    test "left object is not in the map and its orbit is described later in the input" do
      assert """
      COM)B
      C)D
      D)E
      B)C
      """ |> Orbits.to_map() == %{
        "B" => %{o: "COM", dist: 1},
        "C" => %{o: "B", dist: 2},
        "D" => %{o: "C", dist: 3},
        "E" => %{o: "D", dist: 4},
      }
    end
  end

  describe "orbits_count/1" do
    test "total number of orbits" do
      assert %{
        "B" => %{o: "COM", dist: 1},
        "C" => %{o: "B", dist: 2},
        "D" => %{o: "C", dist: 3},
        "E" => %{o: "D", dist: 4},
        "F" => %{o: "E", dist: 5},
        "G" => %{o: "B", dist: 2},
        "H" => %{o: "G", dist: 3},
        "I" => %{o: "D", dist: 4},
        "J" => %{o: "E", dist: 5},
        "K" => %{o: "J", dist: 6},
        "L" => %{o: "K", dist: 7}
      } |> Orbits.orbits_count() == 42

    end
  end


end
