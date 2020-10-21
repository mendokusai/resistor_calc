defmodule Resistor.CliParser do
  def main(bands) do
    output =
      if length(bands) in [4, 5] do
        Resistor.Calc.compute(bands)
      else
        "Incorrect band combination. Handles 4 & 5 band resistors.\nUsage:\n\t./resistor red green blue gold"
      end

    IO.puts(output)
  end
end
