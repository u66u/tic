defmodule TicWeb.GameLive do
  use TicWeb, :live_view

  alias Tic.TicTacToe
  alias Tic.GameSchema
  alias Tic.Repo

  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: TicTacToe.new(), game_id: nil, opponent_id: nil)}
  end

  def handle_event("create_game", %{"opponent_id" => opponent_id}, socket) do
    opponent = Tic.Accounts.get_user!(opponent_id)

    if opponent do
      game = %GameSchema{
        player_1_id: socket.assigns.current_user.id,
        player_2_id: opponent.id
      }
      {:ok, game} = Repo.insert(game)
      board = TicTacToe.new()
               |> Map.put(:player_1_id, game.player_1_id)
               |> Map.put(:player_2_id, game.player_2_id)
               |> Map.put(:current_player_id, game.player_1_id)
      {:noreply, assign(socket, board: board, game_id: game.id, opponent_id: opponent.id)}
    else
      {:noreply, put_flash(socket, :error, "Opponent not found")}
    end
  end

  def handle_event("move", %{"position" => position}, socket) do
    board = TicTacToe.move(socket.assigns.board, String.to_atom(position))
    game_params = %{status: board.game_state}
    game_params = if board.game_state in [:player_1_win, :player_2_win], do: Map.put(game_params, :winner_id, socket.assigns.current_user.id), else: game_params
    Repo.update(GameSchema.changeset(%GameSchema{id: socket.assigns.game_id}, game_params))
    {:noreply, assign(socket, board: board)}
  end

  def render(assigns) do
    ~H"""
    <h1>Tic-Tac-Toe Game</h1>
    <%= if @game_id == nil do %>
      <form phx-submit="create_game">
        <label for="opponent_id">Enter Opponent ID:</label>
        <input type="text" id="opponent_id" name="opponent_id" required />
        <button type="submit">Create Game</button>
      </form>
    <% else %>
      <.live_component module={TicWeb.TicTacToeComponent} id="tic-tac-toe" board={@board} current_user={@current_user} opponent={Tic.Accounts.get_user!(@opponent_id)} />
    <% end %>
    """
  end
end
