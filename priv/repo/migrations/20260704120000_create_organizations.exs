defmodule ThamaniDawa.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :slug, :string
      add :license_number, :string
      add :is_active, :boolean, null: false, default: true
      add :is_subscription_active, :boolean, null: false, default: false
      add :kyc_details, :map, null: false, default: %{}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:organizations, [:slug])
  end
end
