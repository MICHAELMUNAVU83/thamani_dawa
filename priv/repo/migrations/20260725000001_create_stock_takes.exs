defmodule ThamaniDawa.Repo.Migrations.CreateStockTakes do
  use Ecto.Migration

  def change do
    create table(:stock_takes) do
      add :organization_id, references(:organizations, on_delete: :restrict), null: false
      add :site_id, references(:sites, on_delete: :restrict), null: false
      add :status, :string, null: false, default: "draft"
      add :notes, :text
      add :started_by_id, references(:users, on_delete: :restrict), null: false
      add :finalized_by_id, references(:users, on_delete: :restrict)
      add :finalized_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:stock_takes, [:organization_id])
    create index(:stock_takes, [:organization_id, :site_id])
  end
end
