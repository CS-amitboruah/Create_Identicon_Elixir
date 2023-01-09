defmodule Identicon do
  def main(input) do
    input
    |> hash_value
    |> pick_color
    |> build_grid
  end

  # def pick_color(image) do
  #   %Identicon.Image{hex: hex_list} = image
  #   [r, g, b | _tail] = hex_list
  #   [r, g, b]
  # end

  def build_grid(%Identicon.Image{hex: hex}) do
    hex
    |> Enum.chunk(3)
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_value(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
