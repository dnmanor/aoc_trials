defmodule Trebuchet do
  defp remove_letters(list) do
    Enum.filter(list, fn x -> String.match?(x, ~r/\d/) end)
  end

  defp get_callibration(nil, acc) do
    IO.puts(Enum.sum(acc))
    :ok
  end

  defp get_callibration(list, acc) do
    case list do
      [head | tail] ->
        filtered_input = head |> String.graphemes() |> remove_letters()

        if length(filtered_input) === 1 do
          number = String.to_integer("#{hd(filtered_input)}#{hd(filtered_input)}")
          get_callibration(tail, List.insert_at(acc, -1, number))
        else
          [hd | tl] = filtered_input
          number = String.to_integer("#{hd}#{List.last(tl)}")
          get_callibration(tail, List.insert_at(acc, -1, number))
        end

      [] ->
        get_callibration(nil, acc)
    end
  end

  def decipher(file) do
    {state, value} = File.read(file)

    case state do
      :ok ->
        lines = String.split(value, "\n")
        get_callibration(lines, [])

      :error ->
        IO.puts("failed to load file, error: #{value}")
    end
  end
end

Trebuchet.decipher("newcalibration.txt")
