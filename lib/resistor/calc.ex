defmodule Resistor.Calc do
  alias IO.ANSI, as: Color
  @color_aliases [
    blk: :black,
    k: :black,
    brn: :brown,
    r: :red,
    rd: :red,
    org: :orange,
    orng: :orange,
    ylw: :yellow,
    yel: :yellow,
    grn: :green,
    gren: :green,
    g: :green,
    b: :blue,
    bl: :blue,
    blu: :blue,
    v: :violet,
    vi: :violet,
    gr: :grey,
    gray: :grey,
    gry: :grey,
    w: :white,
    wt: :white,
    wh: :white,
    gld: :gold,
    gl: :gold,
    s: :silver,
    sl: :silver,
    sv: :silver
  ]
  @color_directions [
    default: {Color.default_background, Color.default_color},
    black: {Color.black_background, Color.white},
    brown: {Color.color_background(2, 1, 0), Color.white},
    red: {Color.color_background(5, 0, 0), Color.white},
    orange: {Color.color_background(5, 3, 0), Color.black},
    yellow: {Color.yellow_background, Color.black},
    green: {Color.green_background, Color.black},
    blue: {Color.color_background(0, 0, 5), Color.white},
    violet: {Color.color_background(4, 1, 5), Color.white},
    grey: {Color.color_background(4, 4, 4), Color.black},
    white: {Color.white_background, Color.black},
    gold: {Color.color_background(5, 4, 1), Color.black},
    silver: {Color.color_background(4, 4, 4), Color.black}
  ]
  @default_colors Keyword.get(@color_directions, :default)

  @color_codes [
    black: {"0", {1, nil}, nil, :black},
    brown: {"1", {10, nil}, 1, :brown},
    red: {"2", {100, nil}, 2, :red},
    orange: {"3", {1, "K"}, nil, :orange},
    yellow: {"4", {10, "K"}, nil, :yellow},
    green: {"5", {100, "K"}, 0.5, :green},
    blue: {"6", {1, "M"}, 0.25, :blue},
    violet: {"7", {10, "M"}, 0.1, :violet},
    grey: {"8", {100, "M"}, 0.05, :grey},
    white: {"9", {1, "G"}, nil, :white},
    gold: {nil, {0.1, nil}, 5, :gold},
    silver: {nil, {0.01, nil}, 10, :silver}
  ]

  def compute(bands) when length(bands) == 4 do
    [b1, b2, m, t, ] = Enum.map(bands, &get_code/1)

    with {:ok, band1} <- band(b1),
         {:ok, band2} <- band(b2),
         {:ok, multiplier} <- multiplier(m),
         {:ok, tolerance} <- tolerance(t)
    do
      result = compute_four_band(band1, band2, multiplier)
      {{multiplier_value, range}, m_clr} = multiplier
      wrap(band1) <>
      wrap(band2) <>
      wrap({multiplier_value, m_clr}, range) <>
      wrap(tolerance, "%") <>
      wrap({result, :default}, "#{range}Ω")
    else
      {:error, msg} -> "Error: #{msg}"
    end
  end

  def compute(bands) when length(bands) == 5 do
    [b1, b2, b3, m, t, ] = Enum.map(bands, &get_code/1)

    with {:ok, band1} <- band(b1),
         {:ok, band2} <- band(b2),
         {:ok, band3} <- band(b3),
         {:ok, multiplier} <- multiplier(m),
         {:ok, tolerance} <- tolerance(t)
    do
      result = compute_five_band(band1, band2, band3, multiplier)
      {{multiplier_value, range}, m_clr} = multiplier
      wrap(band1) <>
      wrap(band2) <>
      wrap(band3) <>
      wrap({multiplier_value, m_clr}, range) <>
      wrap(tolerance, "%") <>
      wrap({result, :default}, "#{range}Ω")
    else
      {:error, msg} -> "Error: #{msg}"
    end
  end

  defp wrap({value, clr}, ext \\ "") do
    {bkg, clr} = Keyword.get(@color_directions, clr, @default_colors)
    bkg <> clr <> " #{value}#{ext} "
  end

  def compute_four_band({b1, _}, {b2, _}, {{mult, _}, _}) do
    value = b1 <> b2 |> String.to_integer

    reduce(value * mult)
  end

  def compute_five_band({b1, _}, {b2, _}, {b3, _}, {{mult, _}, _}) do
    value = b1 <> b2 <> b3 |> String.to_integer

    reduce(value * mult)
  end

  def reduce(value) when is_float(value), do: Float.round(value, 3)
  def reduce(value), do: value
  def get_code(value) do
    value
    |> String.downcase
    |> String.to_atom
    |> decode_string
    |> get_color_codes
  end

  defp band({value, _, _, clrs}) when is_binary(value), do: {:ok, {value, clrs}}
  defp band(_), do: {:error, "Band couldn't be identified"}
  defp multiplier({_, multiplier, _, clrs}), do: {:ok, {multiplier, clrs}}
  defp multiplier(_), do: {:error, "Multiplier couldn't be identified"}
  defp tolerance({_, _, tolerance, clrs}), do: {:ok, {tolerance, clrs}}
  defp tolerance(_), do: {:error, "Tolerance couldn't be identified"}
  defp decode_string(color_name), do: Keyword.get(@color_aliases, color_name, color_name)
  defp get_color_codes(color), do: Keyword.get(@color_codes, color)
end
