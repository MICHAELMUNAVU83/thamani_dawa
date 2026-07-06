defmodule ThamaniDawa.Repo.Migrations.CreatePatientVisits do
  use Ecto.Migration

  def change do
    create table(:patient_visits) do
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
      add :patient_id, references(:patients, on_delete: :delete_all), null: false
      add :site_id, references(:sites, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :restrict), null: false
      add :visit_type, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:patient_visits, [:organization_id])
    create index(:patient_visits, [:patient_id])
    create index(:patient_visits, [:site_id])
    create index(:patient_visits, [:user_id])
  end
end
