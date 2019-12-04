defmodule Aoc2019.Day4 do
  @type password :: [integer] # 6 numbers
  def part1 do
    178416..676461
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(&valid?/1)
    |> Enum.count()
  end

  @doc """
  Checks if the password is valid.

    ## Examples
    iex> Aoc2019.Day4.valid?([1,1,1,1,1,1])
    true
    iex> Aoc2019.Day4.valid?([2,2,3,4,5,0])
    false
    iex> Aoc2019.Day4.valid?([1,2,3,7,8,9])
    false

  """
  @spec valid?(password, :two_or_more | :just_two) :: bool
  def valid?(password, digits_rule \\ :two_or_more) do
    never_decrease?(password) and two_equal_adjacent_digits?(password, digits_rule)
  end

  @spec never_decrease?(password) :: bool
  defp never_decrease?([a, b, c, d, e, f]) do
    a <= b and b <= c and c <= d and d <= e and e <= f
  end

  @spec two_equal_adjacent_digits?(password, :just_two | :two_or_more) :: bool
  def two_equal_adjacent_digits?(password, :two_or_more) do
    password
    |> count_adjacent_repetitions()
    |> Enum.any?(&match?({_digit, repetition} when repetition >= 2, &1))
  end

  @doc """
  Checks if two adjacent matching digits are not part of a larger group of matching digits.

    ## Examples
      iex> Aoc2019.Day4.two_equal_adjacent_digits?([1,1,2,2,3,3],:just_two)
      true
      iex> Aoc2019.Day4.two_equal_adjacent_digits?([1,2,3,4,4,4],:just_two)
      false
      iex> Aoc2019.Day4.two_equal_adjacent_digits?([1,1,1,1,2,2],:just_two)
      true


  """
  def two_equal_adjacent_digits?(password, :just_two) do
    password
    |> count_adjacent_repetitions()
    |> Enum.any?(&match?({_digit, repetition} when repetition == 2, &1))
  end

  @doc """
  Counts the number of adjacent repetitions

    ## Examples
    iex> Aoc2019.Day4.count_adjacent_repetitions([1,1,2,2,3,3])
    [{3, 2}, {2, 2}, {1, 2}]
  """
  # case in which the prev digit is equal to the current
  def count_adjacent_repetitions(password) do
    count_adjacent_repetitions(password, {nil, 0}, [])
  end
  def count_adjacent_repetitions([], {d, count}, acc), do: [{d, count} | acc]

  def count_adjacent_repetitions([h | rest], {nil, 0}, acc) do
    count_adjacent_repetitions(rest, {h, 1}, acc)
  end

  def count_adjacent_repetitions([d | rest], {d, count}, acc) do
    count_adjacent_repetitions(rest, {d, count + 1}, acc)
  end

  def count_adjacent_repetitions([h | rest], {d, count}, acc) when d != h do
    count_adjacent_repetitions(rest, {h, 1}, [{d, count} | acc])
  end


  def part2 do
    178416..676461
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(fn password -> valid?(password, :just_two) end)
    |> Enum.count()
  end


end
