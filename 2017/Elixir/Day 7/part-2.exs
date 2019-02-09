Code.require_file(Path.join(__DIR__, "Towers.exs"))

File.read!(Path.join(__DIR__, "input.dat"))
|> Towers.get_balanced_weight()
|> IO.inspect(label: "Part 2 result ")
