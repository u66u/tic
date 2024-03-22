defmodule Tic.GameSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :player_1_id, :id
    field :player_2_id, :id
    field :winner_id, :id
    field :status, Ecto.Enum, values: [:in_progress, :draw, :player_1_win, :player_2_win]

    timestamps(type: :utc_datetime)
  end

  def changeset(game, attrs) do
    game
    |> cast(attrs, [:player_1_id, :player_2_id, :winner_id, :status])
    |> validate_required([:player_1_id, :player_2_id])
  end
end
