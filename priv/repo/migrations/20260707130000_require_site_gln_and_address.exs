defmodule ThamaniDawa.Repo.Migrations.RequireSiteGlnAndAddress do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      modify :gln, :string, null: false, unique: true
      modify :address, :string, null: false
    end
  end
end
