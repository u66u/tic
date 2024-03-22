defmodule Tic.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :player_1_id, references(:users, on_delete: :nothing), null: false
      add :player_2_id, references(:users, on_delete: :nothing), null: false
      add :winner_id, references(:users, on_delete: :nothing)
      add :status, :string, default: "in_progress"

      timestamps(type: :utc_datetime)
    end

    create index(:games, [:player_1_id])
    create index(:games, [:player_2_id])
    create index(:games, [:winner_id])
  end
end

