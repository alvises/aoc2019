defmodule Aoc2019.Day2 do
  @moduledoc """
  I'm going to use a Map to get a faster access and update to values at specific addresses
  """
  @type address :: integer
  @type opcode :: 1 | 2 | 99
  @type memory :: %{address => integer}

  @doc """
  Converts the list of intcodes into a Map

    ## Examples
    iex> Aoc2019.Day2.to_map([1,0,0,0,99])
    %{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}

  """
  @spec to_map([integer]) :: memory
  def to_map(intcode_list) do
    # nice way to create a map %{indexes => value} with streams found in https://elixirforum.com/t/transform-a-list-into-an-map-with-indexes-using-enum-module/1523/7
    Stream.zip(Stream.iterate(0, &(&1 + 1)), intcode_list) |> Enum.into(%{})
  end

  @doc """
  Converts a map of incodes to a list

    ## Examples
    iex> Aoc2019.Day2.to_list(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99})
    [1, 0, 0, 0, 99]
  """
  @spec to_list(memory) :: [integer]
  def to_list(intcodes) do
    intcodes
    |> Map.to_list()
    |> Enum.sort()
    |> Enum.map(&(elem(&1, 1)))
  end



  @doc """
  Process the opcode at `address` and returns an updated memory map

    ## Examples
      iex> Aoc2019.Day2.process_instruction(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}, 0)
      {:cont, %{ 0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}}

      iex> Aoc2019.Day2.process_instruction(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}, 4)
      {:halt, %{ 0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}}

  """
  @spec process_instruction(memory, address) :: {:continue | :halt, memory}
  def process_instruction(memory, address) do
    # memory[address + 1] and memory[address + 2] two numbers to add or multiply
    # memory[address + 3] is the position of the result
    case Map.get(memory, address) do
      1 -> {:cont, Map.put(memory, memory[address + 3], memory[memory[address + 1]] + memory[memory[address + 2]])}
      2 -> {:cont, Map.put(memory, memory[address + 3], memory[memory[address + 1]] * memory[memory[address + 2]])}
      99 -> {:halt, memory}
    end
  end

  @doc """
  Process all instructions until 99 opcode is found

    ## Examples
      iex> import Aoc2019.Day2
      iex> intcodes = to_map([1,9,10,3,2,3,11,0,99,30,40,50])
      iex> process_instructions(intcodes) |> to_list()
      [3500,9,10,70,2,3,11,0,99,30,40,50]
  """
  @spec process_instructions(memory) :: memory
  def process_instructions(memory) do
    Stream.iterate(0, &(&1 + 4)) # addresses [0, 4, 8...]
    |> Enum.reduce_while(memory, &process_instruction(&2, &1))
  end

  @doc """
  Process instructions, setting values at address 1 and 2
  """
  @spec process_instructions(memory, integer, integer) :: memory
  def process_instructions(memory, address_1_value, address_2_value) do
    memory
    |> Map.put(1, address_1_value)
    |> Map.put(2, address_2_value)
    |> process_instructions()
  end

  @spec input_to_map(String.t()) :: memory
  def input_to_map(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> to_map()
  end

  @doc """
  Converts the input into a intcodes and then process the intcodes 'till the end
  and returns the value at position 0
  """
  def part1(input) do
    input
    |> input_to_map()
    |> process_instructions(12, 2)
    |> Map.get(0)
  end

  def part1, do: File.read!("inputs/day2.txt") |> part1()


  def part2(input, wanted_result) do
    memory = input_to_map(input)

    [{noun, verb}] =

      Stream.iterate({0, 0}, fn
        {addr_1, 99} -> {addr_1 + 1, 0}
        {addr_1, addr_2} -> {addr_1, addr_2 + 1}
      end)

      |> Stream.filter(fn {addr_1, addr_2} ->
        result =
          memory
          |> process_instructions(addr_1, addr_2)
          |> Map.get(0)
        result == wanted_result
      end)
      |> Enum.take(1)

    100 * noun +  verb
  end

  def part2, do: File.read!("inputs/day2.txt") |> part2(19690720)
end
