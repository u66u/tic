defmodule TicWeb.GameLive do
  use TicWeb, :live_view

  alias Tic.TicTacToe

  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: TicTacToe.new())}
  end

  def handle_event("move", %{"position" => position}, socket) do
    board = TicTacToe.move(socket.assigns.board, String.to_atom(position))
    {:noreply, assign(socket, board: board)}
  end

def render(assigns) do
  ~H"""
  <h1>Tic-Tac-Toe Game</h1>
  <.live_component module={TicWeb.TicTacToeComponent} id="tic-tac-toe" board={@board} />
  """
end
end
