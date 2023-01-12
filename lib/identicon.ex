defmodule Identicon do
  def main(input) do
    input
    |> hash_value
    |> pick_color
    |> build_grid
    |> get_even
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  # def pick_color(image) do
  #   %Identicon.Image{hex: hex_list} = image
  #   [r, g, b | _tail] = hex_list
  #   [r, g, b]
  # end

  def save_image(image, input) do
    File.write("#{input}.png ", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixle_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixle_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = rem(index, 5) * 50

        top_left = {horizontal - vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def get_even(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror(row) do
    [first, second | _tail] = row

    row ++ [second, first]
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
