defmodule ThamaniDawa.LabTests do
  @moduledoc """
  The billable lab test catalog (§4.4): what a lab can order and charge for.
  """

  import Ecto.Query, warn: false
  alias ThamaniDawa.LabTests.LabTest
  alias ThamaniDawa.Repo

  @doc "Lists an organization's lab tests."
  def list_lab_tests(organization_id) do
    Repo.all(from t in LabTest, where: t.organization_id == ^organization_id)
  end

  @doc "Gets a single lab test scoped to an organization. Raises if not found."
  def get_lab_test!(organization_id, id) do
    Repo.get_by!(LabTest, id: id, organization_id: organization_id)
  end

  @doc "Creates a lab test under the given organization."
  def create_lab_test(organization_id, attrs) when is_integer(organization_id) do
    %LabTest{}
    |> LabTest.changeset(attrs)
    |> Ecto.Changeset.put_change(:organization_id, organization_id)
    |> Repo.insert()
  end
end
