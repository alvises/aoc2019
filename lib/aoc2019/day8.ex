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

    # dividing digits in layers
    |> Enum.chunk_every(width * height)

    # stacking the layers
    |> Enum.reduce(fn layer, image ->
        Enum.zip(image, layer)
        |> Enum.map(fn
          # if transparent pixels, take the pixel of the back layer
          # take the front pixel otherwise
          {2, layer_pixel} -> layer_pixel
          {image_pixel, _} -> image_pixel
        end)
    end)

    # colors to the pixels of the final image
    |> Enum.map(fn
      0 -> IO.ANSI.black() <> "#"
      1 -> IO.ANSI.white() <> "#"
    end)

    # divide the final image in row and columns
    # joining them into a string
    |> Enum.chunk_every(width)
    |> Enum.join("\n")
  end
end
