defmodule ThamaniDawa.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
      add :site_id, references(:sites, on_delete: :delete_all), null: false
      add :generic_name, :string
      add :brand_name, :string
      add :category, :string
      add :uom, :string
      add :gtin, :string
      add :is_otc, :boolean, null: false, default: false
      add :is_dangerous_drug, :boolean, null: false, default: false
      add :reorder_level, :integer
      add :price, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:organization_id])
    create index(:products, [:site_id])
    create unique_index(:products, [:organization_id, :gtin])
  end
end
