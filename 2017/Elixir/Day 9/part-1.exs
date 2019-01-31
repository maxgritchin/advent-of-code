Code.require_file(Path.join(__DIR__, "base.exs"))

File.read!(Path.join(__DIR__, "data.dat"))
|> Groups.score!()
|> IO.inspect(label: "Part 1 result ")
