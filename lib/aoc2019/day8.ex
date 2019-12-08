defmodule Aoc2019.Day8 do

  def digits(input) do
    String.to_charlist(input)
    |> Enum.map(& &1 - ?0)
  end

  #123456789012
  def part1(input) do
    layer_size = 25*6
    layer =
      input
      |> digits()
      |> Enum.chunk_every(layer_size)
      |> Enum.min_by(fn layer -> Enum.count(layer, & &1 == 0) end)
    Enum.count(layer, & &1 == 1) * Enum.count(layer, & &1 == 2)
  end

  def part2(input) do
    width = 25
    height = 6
    input
    |> digits()
    |> Enum.chunk_every(width * height)
    |> Enum.reduce(nil, fn
      layer, nil -> layer
      layer, image ->
        Enum.zip(image, layer)
        |> Enum.map(fn
          {2, layer_pixel} -> layer_pixel
          {image_pixel, _} -> image_pixel
        end)
    end)
    |> Enum.map(fn
      0 -> IO.ANSI.black() <> "#"
      1 -> IO.ANSI.white() <> "#"
    end)
    |> Enum.chunk_every(width)
    |> Enum.join("\n")
  end
end
