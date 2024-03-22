defmodule TicWeb.TicTacToeComponent do
  use TicWeb, :live_component

  defp player_mark(board, position) do
    case Map.get(board, position) do
      " " -> " "
      mark when board.player_1_id == board.current_player_id -> mark
      "X" -> "O"
      "O" -> "X"
    end
  end

  def render(assigns) do
    ~H"""
    <div class="tic-tac-toe-board">
      <div class="row">
        <div class="cell" phx-click="move" phx-value-position="a1"><%= @board.a1 %></div>
        <div class="cell" phx-click="move" phx-value-position="a2"><%= @board.a2 %></div>
        <div class="cell" phx-click="move" phx-value-position="a3"><%= @board.a3 %></div>
      </div>
      <div class="row">
        <div class="cell" phx-click="move" phx-value-position="b1"><%= @board.b1 %></div>
        <div class="cell" phx-click="move" phx-value-position="b2"><%= @board.b2 %></div>
        <div class="cell" phx-click="move" phx-value-position="b3"><%= @board.b3 %></div>
      </div>
      <div class="row">
        <div class="cell" phx-click="move" phx-value-position="c1"><%= @board.c1 %></div>
        <div class="cell" phx-click="move" phx-value-position="c2"><%= @board.c2 %></div>
        <div class="cell" phx-click="move" phx-value-position="c3"><%= @board.c3 %></div>
      </div>
      <div class="cell" phx-click="move" phx-value-position="a1"><%= player_mark(@board, :a1) %></div>
    </div>


    """
  end
end
