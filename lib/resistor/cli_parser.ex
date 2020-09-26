defmodule Resistor.CliParser do
  def main(args) do
    options = [switches: [file: :string],aliases: [f: :file]]
    {_, bands, _} = OptionParser.parse(args, options)

    Resistor.Calc.compute(bands)
    |> IO.puts
  end
end
