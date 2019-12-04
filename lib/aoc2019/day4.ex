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
  @spec valid?(password) :: bool
  def valid?(password) do
    never_decrease?(password) and two_same_adjacent?(password)
  end

  @spec never_decrease?(password) :: bool
  defp never_decrease?([a, b, c, d, e, f]) do
    a <= b and b <= c and c <= d and d <= e and e <= f
  end

  @spec two_same_adjacent?(password) :: bool
  defp two_same_adjacent?(password) do
    password
    |> Enum.chunk_every(2, 1)
    |> Enum.any?(fn
      [a, b] -> a == b
      _ -> false
    end)
  end
end
