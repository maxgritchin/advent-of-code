_="""
A new system policy has been put in place that requires all accounts to use a passphrase instead of simply a password. A passphrase consists of a series of words (lowercase letters) separated by spaces.

To ensure security, a valid passphrase must contain no duplicate words.

## Example

aa bb cc dd ee is valid.
aa bb cc dd aa is not valid - the word aa appears more than once.
aa bb cc dd aaa is valid - aa and aaa count as different words.

## Task

The system's full passphrase list is available as your puzzle input. How many passphrases are valid?
"""

defmodule Analizer do
  @moduledoc """
  Phrases analizer

  ## Overview

  This module has methods to anilize if any pahrases have duplicates in a passphrass.
  The approach includes the passphrase iteration (by word) and check if the word already has been met.

  ## Example

  aa bb cc dd ee is valid.
  aa bb cc dd aa is not valid - the word aa appears more than once.

  """

  def has_duplicates(phrase) when is_bitstring(phrase) do
    duplicates? = fn phrase, map, fun ->
      cond do
        phrase == [] -> false
        true ->
          [word | rest] = phrase
          cond do
            map |> MapSet.member?(word) -> true
            true -> fun.(rest, MapSet.put(map, word), fun)
          end
      end
    end

    phrase
    #|> IO.inspect(label: "Input phraze ")
    |> String.split(" ")
    |> duplicates?.(MapSet.new(), duplicates?)
    #|> IO.inspect(label: "Has duplicates ")
  end
end

File.read!("passphrases.dat")
|> String.split("\n")
|> Enum.filter(fn p -> Analizer.has_duplicates(p) == false end)
|> length
|> IO.inspect(label: "Count of valid passphrases ")
