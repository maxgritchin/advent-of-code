_="""
  https://adventofcode.com/2017/day/12
"""

Code.require_file(Path.join(__DIR__, "DigitalPlumber.exs"))

# RUN
File.read!(Path.join(__DIR__, "input.dat"))
|> String.split("\n")
|> Enum.map(fn x ->
  [key, values] = String.split(x, "<->")
  key = String.trim(key) |> String.to_integer
  values = String.split(values, ",") |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)

  {key, values}
end)
|> Map.new
|> DigitalPlumber.count_of_programs(0)
|> IO.inspect(label: "Result")
