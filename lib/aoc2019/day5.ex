defmodule Aoc2019.Day5 do

  @moduledoc """
  I'm going to use a Map to get a faster access and update to values at specific addresses
  """
  @type address :: integer
  @type nount :: integer
  @type verb :: integer
  @type param_mode :: 0 | 1 # 0 = position, 1 = immediate
  @type opcode :: 1 | 2 | 3 | 4 | 5 | 99 # 1 = add, 2 = mul, 3 = read stdin, 4 = write stdout, 99 = halt
  @type memory :: %{address => integer}

  @doc """
  Converts the list of intcodes into a Map

    ## Examples
    iex> alias Aoc2019.Day5, as: VM
    iex> VM.to_map([1,0,0,0,99])
    %{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}

  """
  @spec to_map([integer]) :: memory
  def to_map(intcode_list) do
    Stream.zip(Stream.iterate(0, &(&1 + 1)), intcode_list) |> Enum.into(%{})
  end

  @doc """
  Converts a map of incodes to a list

    ## Examples
    iex> alias Aoc2019.Day5, as: VM
    iex> VM.to_list(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99})
    [1, 0, 0, 0, 99]
  """
  @spec to_list(memory) :: [integer]
  def to_list(intcodes) do
    intcodes
    |> Map.to_list()
    |> Enum.sort()
    |> Enum.map(&(elem(&1, 1)))
  end

  defp add(memory, addr_mode_1, addr_mode_2, addr_mode_result) do
    put(memory, addr_mode_result, get(memory,addr_mode_1) + get(memory,addr_mode_2))
  end

  defp mul(memory, addr_mode_1, addr_mode_2, addr_mode_result) do
    put(memory, addr_mode_result, get(memory,addr_mode_1) * get(memory,addr_mode_2))
  end


  @doc """
  Process the opcode at `address` and returns an updated memory map

    ## Examples
      iex> import Aoc2019.Day5
      iex> process_instruction(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}, 0)
      {4, %{ 0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}}
      iex> process_instruction(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}, 4)
      {:halt, %{ 0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}}
  """
  @spec process_instruction(memory, address, function) :: {address | :halt, memory}
  def process_instruction(memory, address, gets_fun \\ &(IO.gets(&1))) when is_function(gets_fun) do
    # memory[address + 1] and memory[address + 2] two numbers to add or multiply
    # memory[address + 3] is the position of the result

    case Map.get(memory, address) |> opcode_and_modes() do
      {1, modes} -> {address + 4, add(memory, {address + 1, mode(modes, 0)}, {address + 2, mode(modes,1)}, {address + 3, mode(modes, 2)})}
      {2, modes} -> {address + 4, mul(memory, {address + 1, mode(modes, 0)}, {address + 2, mode(modes,1)}, {address + 3, mode(modes, 2)})}
      {3, modes} -> {address + 2, read_input(memory, {address + 1, mode(modes,0)}, gets_fun)}
      {4, modes} -> {address + 2, write_output(memory, {address + 1, mode(modes,0)})}
      {5, modes} -> jump_if_true(memory, address, modes)
      # {6, modes} -> jump_if_false(memory, address, modes)
      {99, _} -> {:halt, memory}
    end
  end

  defp mode(modes, idx), do: Enum.at(modes, idx, 0)

  @spec get(memory, {address, param_mode}) :: integer
  # param mode
  def get(memory, {address, 0}), do: memory[memory[address]]
  # immediate mode
  def get(memory, {address, 1}), do: memory[address]

  @spec put(memory, {address, param_mode}, integer) :: memory
  def put(memory, {result_address, 0}, value) do
    Map.put(memory, memory[result_address], value)
  end

  def put(memory, {result_address, 1}, value) do
    Map.put(memory, result_address, value)
  end

  @doc """
  if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter.
  """
  @spec jump_if_true(memory, address, [param_mode]) :: {address, memory}
  def jump_if_true(memory, address, modes) do
    if get(memory, {address + 1, mode(modes, 0)}) != 0 do
      pointer = get(memory, {address + 2, mode(modes, 1)})
      {pointer, memory}
    else
      {address + 3, memory}
    end
  end

  @doc """
  if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
  """
  @spec jump_if_false(memory, address, [param_mode]) :: {address, memory}
  def jump_if_false(memory, address, modes) do
    if get(memory, {address + 1, mode(modes, 0)}) == 0 do
      pointer = get(memory, {address + 2, mode(modes, 1)})
      {pointer, memory}
    else
      {address + 3, memory}
    end
  end

  @doc """
  Reads input from user, sets it into memory and returns the memory
    ## Examples
    iex> import Aoc2019.Day5
    iex> read_input(%{4 => 0}, {4, 0}, fn _-> "123" end)
    %{0 => 123, 4 => 0}
  """
  @spec read_input(memory, {address, param_mode}, function) :: memory
  def read_input( memory, addr_mode_result, gets_fun) when is_function(gets_fun) do
    num = gets_fun.("number?\n") |> String.trim() |> String.to_integer()
    put(memory, addr_mode_result, num)
  end

  def write_output(memory, addr_mode_value) do
    value = get(memory, addr_mode_value)
    IO.puts("#{value}")
    memory
  end


  @doc """
  Parses the first part of the instruction to get opcode and parameter modes
    ## Examples
    iex> alias Aoc2019.Day5, as: VM
    iex> VM.opcode_and_modes(1002)
    {2, [0, 1]}
    iex> VM.opcode_and_modes(1101)
    {1, [1, 1]}
    iex> VM.opcode_and_modes(99)
    {99, []}

  """
  @spec opcode_and_modes(integer) :: {opcode, [param_mode]}
  def opcode_and_modes(num) do
    case Integer.digits(num) |> Enum.reverse() do
      [o2, o1 | modes] -> {o1*10 + o2, modes}
      [opcode] -> {opcode, []}
    end

  end

  def opcode_to_atom(opcode) do
    case opcode do
      1 -> :add
      2 -> :mul
      99 -> :halt
    end
  end

  @doc """
  Process all instructions until 99 opcode is found

    ## Examples
      iex> alias Aoc2019.Day5, as: VM
      iex> intcodes = VM.to_map([1,9,10,3,2,3,11,0,99,30,40,50])
      iex> VM.process_instructions(intcodes, fn _->"123" end) |> VM.to_list()
      [3500,9,10,70,2,3,11,0,99,30,40,50]
  """
  @spec process_instructions(memory, function) :: memory
  def process_instructions(memory, gets_fn) when is_function(gets_fn),
    do: process_instructions(memory, 0, gets_fn)

  @spec process_instructions(memory, address, function) :: memory
  def process_instructions(memory, address, gets_fn) when is_function(gets_fn) do
    case process_instruction(memory, address, gets_fn) do
      {:halt, memory} -> memory
      {next_address, memory} -> process_instructions(memory, next_address, gets_fn)
    end
  end


  @spec input_to_map(String.t()) :: memory
  def input_to_map(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> to_map()
  end

  @doc """
  Runs part1
    ## Examples
      iex> alias Aoc2019.Day5, as: VM
      iex> VM.part1("1002,4,3,4,33")
      %{0 => 1002, 1 => 4, 2 => 3, 3 => 4, 4 => 99}
      iex> VM.part1("1101,100,-1,4,0") |> Map.get(4)
      99
  """
  def part1(input, gets_fun \\ &(IO.gets(&1))) do
    input
    |> input_to_map()
    |> process_instructions(gets_fun)
  end

  def part1, do: File.read!("inputs/day5.txt") |> part1()



end
