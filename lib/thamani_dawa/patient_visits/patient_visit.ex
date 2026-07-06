defmodule ThamaniDawa.PatientVisits.PatientVisit do
  use Ecto.Schema
  import Ecto.Changeset

  @visit_types [:pharmacy, :lab]

  schema "patient_visits" do
    field :organization_id, :id
    field :patient_id, :id
    field :site_id, :id
    field :user_id, :id
    field :visit_type, Ecto.Enum, values: @visit_types

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(patient_visit, attrs) do
    patient_visit
    |> cast(attrs, [:patient_id, :site_id, :user_id, :visit_type])
    |> validate_required([:patient_id, :site_id, :user_id, :visit_type])
    |> foreign_key_constraint(:patient_id)
    |> foreign_key_constraint(:site_id)
    |> foreign_key_constraint(:user_id)
  end

  @doc "The valid patient visit types."
  def visit_types, do: @visit_types
end
