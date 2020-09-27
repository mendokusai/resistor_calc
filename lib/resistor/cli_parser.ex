defmodule Resistor.CliParser do
  def main(args) do
    options = [switches: [file: :string],aliases: [f: :file]]
    {_, bands, _} = OptionParser.parse(args, options)

    if length(bands) in [4, 5] do
      Resistor.Calc.compute(bands)
      |> IO.puts
    else
      IO.puts "Incorrect band combination. Handles 4 & 5 band resistors.\nUsage:\n\t./resistor red green blue gold"
    end
  end
end
