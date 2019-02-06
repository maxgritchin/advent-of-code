defmodule AsciiCodes do
  use Bitwise

  @standart_extension <<17,31,73,47,23>>

  @doc """
  Generates special list of codes based on the given string
  It adds postfix to the end of the result string

  ## Examples
    iex>AsciiCodes.generate("1,2,3")
    [49,44,50,44,51,17,31,73,47,23]

  """
  def generate(list, n) do
    list <> @standart_extension
    |> to_charlist()
    |> List.duplicate(n)
    |> List.flatten()
  end

  @doc """
  Gets dense hash from the given sparse hash
  """
  def get_dense_hash(sparse_hash) do
    sparse_hash
    |> Enum.chunk_every(16)
    |> Enum.map(fn chunk ->
      chunk |> Enum.reduce(0, fn x, acc -> acc ^^^ x end)
    end)
  end
end

# TESTS
ExUnit.start

defmodule AsciiCodesUnitTests do
  use ExUnit.Case

  test "generate ASCII representaton" do
    assert AsciiCodes.generate("1,2,3", 2) == [49,44,50,44,51,17,31,73,47,23,49,44,50,44,51,17,31,73,47,23]
  end

  test "get dense hash" do
    # arrange
    list = [65,27,9,1,4,3,40,50,91,7,6,0,2,5,68,22]

    #act
    [result | _] = AsciiCodes.get_dense_hash(list)

    # assert
    assert result == 64
  end
end
