_="""
  https://adventofcode.com/2017/day/11
"""

Code.require_file(Path.join(__DIR__, "HexGrid.exs"))

# RUN
File.read!(Path.join(__DIR__, "input.dat"))
|> String.trim
|> String.split(",")
|> HexGrid.furthers_number_of_steps
|> IO.inspect(label: "Result")
