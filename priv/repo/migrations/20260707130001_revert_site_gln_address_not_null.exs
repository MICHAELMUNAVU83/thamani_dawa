defmodule ThamaniDawa.Repo.Migrations.RevertSiteGlnAddressNotNull do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      modify :gln, :string, null: true
      modify :address, :string, null: true
    end
  end
end
