Code.require_file(Path.join(__DIR__, "KnotHash.exs"))

"187,254,0,81,169,219,1,190,19,102,255,56,46,32,2,216"
|> KnotHash.get_hash()
|> IO.inspect(label: "Part 2 result ")


