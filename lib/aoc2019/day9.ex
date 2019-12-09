defmodule Aoc2019.Day9 do
  @moduledoc """
  I'm going to use a Map to get a faster access and update to values at specific addresses
  """
  @type address :: integer
  @type nount :: integer
  @type verb :: integer
  @type param_mode :: 0 | 1 | 2 # 0 = position, 1 = immediate, 2 = relative
  @type opcode :: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 99 # 1 = add, 2 = mul, 3 = read input, 4 = write output, 9 = update relative base, 99 = halt
  @type memory :: %{address => integer}
  @type vm :: %{memory: memory, ip: integer, input: term(), output: [integer], halted: boolean, relative_base: integer}

  @doc """
  Converts the list of intcodes into a Map

    ## Examples
    iex> alias Aoc2019.Day9, as: VM
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
    iex> alias Aoc2019.Day9, as: VM
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


  @doc """
  Process the opcode at `address` and returns an updated memory map
  """
  @spec process_instruction(vm) :: vm
  def process_instruction(%{memory: memory, ip: ip}=vm)do
    # memory[address + 1] and memory[address + 2] two numbers to add or multiply
    # memory[address + 3] is the position of the result
    opcode_modes = Map.get(memory, ip) |> opcode_and_modes()
    case opcode_modes do
      {1, modes} -> add(vm, modes)
      {2, modes} -> mul(vm, modes)
      {3, modes} -> read_input(vm, modes)
      {4, modes} -> write_output(vm, modes)
      {5, modes} -> jump_if_true(vm, modes)
      {6, modes} -> jump_if_false(vm, modes)
      {7, modes} -> less_then(vm, modes)
      {8, modes} -> equals(vm, modes)
      {9, modes} -> update_relative_base(vm, modes)
      {99, _} -> %{vm | halted: true}
    end
  end

  defp mode(modes, idx), do: Enum.at(modes, idx, 0)

  @spec get(vm, {address, param_mode}) :: integer
  # param mode
  def get(vm, {address, 0}), do: vm.memory[vm.memory[address]]
  # immediate mode
  def get(vm, {address, 1}), do: vm.memory[address]
  # relative mode
  def get(vm, {address, 2}) do
    relative_address = vm.memory[address] + vm.relative_base
    vm.memory[relative_address]
  end

  @spec put(memory, {address, param_mode}, integer) :: memory
  def put(memory, {result_address, 0}, value) do
    Map.put(memory, memory[result_address], value)
  end

  def put(memory, {result_address, 1}, value) do
    Map.put(memory, result_address, value)
  end

  @spec add(vm, [param_mode]) :: vm
  defp add(vm, modes) do
    v1 = get(vm, {vm.ip + 1, mode(modes, 0)})
    v2 = get(vm, {vm.ip + 2, mode(modes, 1)})
    r_addr_mode = {vm.ip + 3, mode(modes, 2)}

    %{vm | ip: vm.ip + 4, memory: put(vm.memory, r_addr_mode, v1 + v2)}
  end

  @spec mul(vm, [param_mode]) :: vm
  defp mul(vm, modes) do
    v1 = get(vm, {vm.ip + 1, mode(modes, 0)})
    v2 = get(vm, {vm.ip + 2, mode(modes, 1)})
    r_addr_mode = {vm.ip + 3, mode(modes, 2)}

    %{vm | ip: vm.ip + 4, memory: put(vm.memory, r_addr_mode, v1 * v2)}
  end


  @doc """
  if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter.
  """
  @spec jump_if_true(vm, [param_mode]) :: vm
  def jump_if_true(vm, modes) do
    if get(vm, {vm.ip + 1, mode(modes, 0)}) != 0 do
      %{vm | ip: get(vm, {vm.ip + 2, mode(modes, 1)})}
    else
      %{vm | ip: vm.ip + 3}
    end
  end

  @doc """
  if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
  """
  @spec jump_if_false(vm, [param_mode]) :: vm
  def jump_if_false(%{ip: ip}=vm, modes) do
    if get(vm, {ip + 1, mode(modes, 0)}) == 0 do
      %{vm | ip: get(vm, {ip + 2, mode(modes, 1)})}
    else
      %{vm | ip: ip + 3}
    end
  end

  @doc """
  if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  """
  @spec less_then(vm, [param_mode]) :: vm
  def less_then(vm, modes) do
    v1 = get(vm, {vm.ip + 1, mode(modes, 0)})
    v2 = get(vm, {vm.ip + 2, mode(modes, 1)})
    r_addr_mode = {vm.ip + 3, mode(modes, 2)}
    new_ip = vm.ip + 4

    if v1 < v2 do
      %{vm | ip: new_ip, memory: put(vm.memory, r_addr_mode, 1)}

    else
      %{vm | ip: new_ip, memory: put(vm.memory, r_addr_mode, 0)}
    end
  end

  @doc """
  if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  """
  @spec equals(vm, [param_mode]) :: vm
  def equals(vm, modes) do
    v1 = get(vm, {vm.ip + 1, mode(modes, 0)})
    v2 = get(vm, {vm.ip + 2, mode(modes, 1)})
    r_addr_mode = {vm.ip + 3, mode(modes, 2)}
    new_ip = vm.ip + 4

    if v1 == v2 do
      %{vm | ip: new_ip, memory: put(vm.memory, r_addr_mode, 1)}
    else
      %{vm | ip: new_ip, memory: put(vm.memory, r_addr_mode, 0)}
    end
  end


  @spec read_input(vm, [param_mode]) :: vm
  defp read_input(vm, modes) do
    addr_mode_result = {vm.ip + 1, mode(modes,0)}
    {{:value, num}, input} = :queue.out(vm.input)
    %{vm | ip: vm.ip + 2, memory: put(vm.memory, addr_mode_result, num), input: input}
  end

  @spec write_output(vm, [param_mode]) :: vm
  defp write_output(vm, modes) do
    value = get(vm, {vm.ip + 1, mode(modes,0)})
    %{vm | ip: vm.ip + 2, output:  vm.output ++ [value]}
  end

  @spec update_relative_base(vm, [param_mode]) :: vm
  defp update_relative_base(vm, modes) do
    value = get(vm, {vm.ip + 1, mode(modes,0)})
    %{vm | ip: vm.ip + 2, relative_base: vm.relative_base + value}
  end

  @doc """
  Parses the first part of the instruction to get opcode and parameter modes
    ## Examples
    iex> alias Aoc2019.Day9, as: VM
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


  @spec input_to_map(String.t()) :: memory
  def input_to_map(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> to_map()
  end

  @spec new_vm(memory) :: vm
  def new_vm(memory, input \\ []) do
    %{memory: memory, ip: 0, input: :queue.from_list(input), output: [], halted: false, relative_base: 0}
  end

  @doc """
  Runs until the vm is halted: true, or it has an output
  """
  @spec run(vm) :: vm
  def run(%{halted: true}=vm), do: vm
  def run(%{output: [_output]}=vm), do: vm

  def run(vm) do
    vm
    |> process_instruction()
    |> run()
  end

  @spec add_input(vm, integer) :: vm
  def add_input(vm, input_element) do
    %{vm | input: :queue.in(input_element, vm.input)}
  end

  @spec pop_output(vm) :: {integer, vm}
  def pop_output(%{output: [elem | rest]}=vm) do
    {elem, %{vm | output: rest}}
  end

  def pop_output(%{output: []}=vm) do
    {nil, vm}
  end


end
