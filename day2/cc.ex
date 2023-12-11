defmodule CubeConundrum do
  @real_set %{"red" => 12, "green" => 13, "blue" => 14}

  defp round_possible(input) do
    s_strings =
      input |> String.trim() |> String.downcase() |> String.replace(";", ",") |> String.split(",")

    Enum.all?(s_strings, fn x ->
      [count_str, color] = x |> String.trim() |> String.split(" ")
      count = String.to_integer(count_str)
      number_in_set = Map.get(@real_set, color, 0)
      count <= number_in_set
    end)
  end

  defp check_possibilty(_, -1, acc) do
    IO.inspect(acc)
    IO.puts("Sum of possible IDs -> #{Enum.sum(acc)}")
  end

  defp check_possibilty(rounds, index, acc) do
    round = Enum.at(rounds, index)

    [game_name, picks] = String.split(round, ":")
    [_, game_id] = String.split(game_name)

    if round_possible(picks) do
      new_acc = acc ++ [String.to_integer(game_id)]
      check_possibilty(rounds, index - 1, new_acc)
    else
      check_possibilty(rounds, index - 1, acc)
    end
  end

  def analyze(file) do
    {state, value} = File.read(file)

    case state do
      :ok ->
        rounds = String.split(value, "\n")
        check_possibilty(rounds, length(rounds) - 1, [])

      :error ->
        IO.puts("failed to load file, error: #{value}")
    end
  end
end

CubeConundrum.analyze("gamerecords.txt")
