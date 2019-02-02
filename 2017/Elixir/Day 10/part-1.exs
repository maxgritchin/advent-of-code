Code.require_file(Path.join(__DIR__, "Base.exs"))

lengths = "187,254,0,81,169,219,1,190,19,102,255,56,46,32,2,216"
|> String.split(",")
|> Enum.map(&String.to_integer(&1))

get_first_and_second = fn x->
  {Map.get(x, 1), Map.get(x, 2)}
end

multiply = fn {a, b} ->  a * b end

KnotHash.calc!(Enum.to_list(0..255), lengths)
|> IO.inspect(label: "Intermidiate ")
|> get_first_and_second.()
|> multiply.()
|> IO.inspect(label: "Part 1 result ")
