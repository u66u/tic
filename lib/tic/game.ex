defmodule Tic.TicTacToe do
  defstruct a1: " ", a2: " ", a3: " ",
            b1: " ", b2: " ", b3: " ",
            c1: " ", c2: " ", c3: " ",
            current_player: "X", game_state: :playing,
            player_1_id: nil, player_2_id: nil, current_player_id: nil

  def new() do
    %Tic.TicTacToe{}
  end

  def move(board, position) do
    case {Map.get(board, position), board.current_player_id == player_id(board, board.current_player)} do
      {" ", true} ->
        next_player = next_player(board.current_player)
        board
        |> Map.put(position, board.current_player)
        |> Map.put(:current_player, next_player)
        |> Map.put(:current_player_id, player_id(board, next_player))
        |> check_game_state()
      {" ", false} ->
        {:error, "Invalid move. It's not your turn."}
      _ ->
        {:error, "Invalid move. Cell #{position} is already occupied."}
    end
  end

  defp player_id(board, "X"), do: board.player_1_id
  defp player_id(board, "O"), do: board.player_2_id

  defp next_player("X"), do: "O"
  defp next_player("O"), do: "X"

  defp check_game_state(board) do
    cond do
      winner(board, "X") -> %{board | game_state: :player_1_win}
      winner(board, "O") -> %{board | game_state: :player_2_win}
      full?(board) -> %{board | game_state: :tie}
      true -> board
    end
  end

  defp winner(board, player) do
    [
      [board.a1, board.a2, board.a3],
      [board.b1, board.b2, board.b3],
      [board.c1, board.c2, board.c3],
      [board.a1, board.b1, board.c1],
      [board.a2, board.b2, board.c2],
      [board.a3, board.b3, board.c3],
      [board.a1, board.b2, board.c3],
      [board.a3, board.b2, board.c1]
    ]
    |> Enum.any?(fn row -> Enum.all?(row, &(&1 == player)) end)
  end

  defp full?(board) do
    Enum.all?(Map.values(board), &(&1 != " "))
  end

  def play() do
    board = Tic.TicTacToe.new()
    play_turn(board)
  end

  defp play_turn(%{game_state: game_state} = board) when game_state in [:player_1_win, :player_2_win, :tie] do
    IO.puts("\n#{board}")
    IO.puts("Game over! Result: #{game_state}")
  end

  defp play_turn(board) do
    IO.puts("\n#{board}")
    IO.puts("It's Player #{board.current_player}'s turn.")
    position = get_move(board)
    board = Tic.TicTacToe.move(board, position)
    play_turn(board)
  end

  defp get_move(board) do
    position =
      IO.gets("Enter the position you want to play: ")
      |> String.trim()
      |> String.downcase()

    case validate_position(position) do
      {:ok, valid_position} ->
        case Map.get(board, valid_position) do
          " " -> valid_position
          _ ->
            IO.puts("Position #{position} is already occupied. Please try again.")
            get_move(board)
        end
      :error ->
        IO.puts("Invalid position: #{position}. Please enter a valid position (a1, a2, a3, b1, b2, b3, c1, c2, c3).")
        get_move(board)
    end
  end

  def save_game(game) do
    %Tic.GameSchema{
      player_1_id: game.player_1_id,
      player_2_id: game.player_2_id,
      winner_id: winner_id(game),
      status: game.game_state
    }
    |> Tic.Repo.insert()
  end

  defp winner_id(%{game_state: :player_1_win}), do: :player_1_id
  defp winner_id(%{game_state: :player_2_win}), do: :player_2_id
  defp winner_id(_), do: nil

  @doc """
    Validates the given position and returns {:ok, valid_position} if it's valid,
    or :error if it's invalid.
    """
  def validate_position(position) do
      valid_positions = ~w(a1 a2 a3 b1 b2 b3 c1 c2 c3)
      if position in valid_positions, do: {:ok, String.to_atom(position)}, else: :error
    end
  end

defimpl String.Chars, for: Tic.TicTacToe do
  def to_string(board) do
    """
     #{board.a1} | #{board.a2} | #{board.a3}   a1 | a2 | a3
    ---+---+---
     #{board.b1} | #{board.b2} | #{board.b3}   b1 | b2 | b3
    ---+---+---
     #{board.c1} | #{board.c2} | #{board.c3}   c1 | c2 | c3
    """
  end
end
