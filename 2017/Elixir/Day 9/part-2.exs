Code.require_file(Path.join(__DIR__, "base.exs"))

File.read!(Path.join(__DIR__, "data.dat"))
|> Groups.calc_garbage_chars!()
|> IO.inspect(label: "Part 2 result ")
