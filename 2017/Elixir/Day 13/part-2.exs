_="""
  https://adventofcode.com/2017/day/13
"""

Code.require_file(Path.join(__DIR__, "Firewall.exs"))

# RUN
File.read!(Path.join(__DIR__, "input.dat"))
|> String.split("\n")
|> Enum.map(fn x ->
    [step, depth] = String.split(x, ":")
    {String.to_integer(step), String.to_integer(String.trim(depth))}
end)
|> Firewall.fewest_number_of_picoseconds(0)
|> IO.inspect(lebel: "Result")
