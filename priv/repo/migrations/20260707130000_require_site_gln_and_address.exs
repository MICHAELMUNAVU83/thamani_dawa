defmodule ThamaniDawa.Repo.Migrations.RequireSiteGlnAndAddress do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      modify :gln, :string, null: false
      modify :address, :string, null: false
    end

    create unique_index(:sites, [:gln])
  end
end