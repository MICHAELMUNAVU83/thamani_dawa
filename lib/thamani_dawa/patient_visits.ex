defmodule ThamaniDawa.PatientVisits do
  @moduledoc """
  Patient visits link a patient to a site (and the staff member who served
  them) for a single encounter — lab orders and prescriptions can optionally
  be tied back to the visit they arose from.
  """

  import Ecto.Query, warn: false
  alias ThamaniDawa.PatientVisits.PatientVisit
  alias ThamaniDawa.Repo

  @doc "Lists an organization's patient visits."
  def list_patient_visits(organization_id) do
    Repo.all(from pv in PatientVisit, where: pv.organization_id == ^organization_id)
  end

  @doc "Gets a single patient visit scoped to an organization. Raises if not found."
  def get_patient_visit!(organization_id, id) do
    Repo.get_by!(PatientVisit, id: id, organization_id: organization_id)
  end

  @doc "Creates a patient visit under the given organization."
  def create_patient_visit(organization_id, attrs) when is_integer(organization_id) do
    %PatientVisit{}
    |> PatientVisit.changeset(attrs)
    |> Ecto.Changeset.put_change(:organization_id, organization_id)
    |> Repo.insert()
  end
end
