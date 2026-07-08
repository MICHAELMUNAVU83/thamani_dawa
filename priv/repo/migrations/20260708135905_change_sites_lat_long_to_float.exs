defmodule ThamaniDawa.Repo.Migrations.ChangeSitesLatLongToFloat do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      modify :lat, :float, from: :integer
      modify :long, :float, from: :integer
    end
  end
end
