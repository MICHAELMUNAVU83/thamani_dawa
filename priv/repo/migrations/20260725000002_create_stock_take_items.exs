defmodule ThamaniDawa.Repo.Migrations.CreateStockTakeItems do
  use Ecto.Migration

  def change do
    create table(:stock_take_items) do
      add :organization_id, references(:organizations, on_delete: :restrict), null: false
      add :stock_take_id, references(:stock_takes, on_delete: :delete_all), null: false
      add :batch_id, references(:batches, on_delete: :restrict), null: false
      add :expected_quantity, :integer, null: false
      add :counted_quantity, :integer
      add :variance, :integer
      add :counted_by_id, references(:users, on_delete: :restrict)
      add :counted_at, :utc_datetime
      add :notes, :text

      timestamps()
    end

    create index(:stock_take_items, [:organization_id])
    create index(:stock_take_items, [:stock_take_id])
    create unique_index(:stock_take_items, [:stock_take_id, :batch_id])
  end
end
