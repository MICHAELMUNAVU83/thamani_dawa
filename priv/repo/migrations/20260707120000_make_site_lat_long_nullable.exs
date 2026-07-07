defmodule ThamaniDawa.Repo.Migrations.MakeSiteLatLongNullable do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      modify :lat, :integer, null: true
      modify :long, :integer, null: true
    end
  end
end
