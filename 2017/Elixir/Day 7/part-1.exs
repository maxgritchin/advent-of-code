Code.require_file(Path.join(__DIR__, "Towers.exs"))

File.read!(Path.join(__DIR__, "input.dat"))
|> Towers.get_base_tower()
|> IO.inspect(label: "Part 1 result ")
