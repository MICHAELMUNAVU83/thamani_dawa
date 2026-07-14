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

  @doc "Updates a lab test. Raises if the test does not belong to the given organization."
  def update_lab_test(organization_id, %LabTest{} = lab_test, attrs) do
    if lab_test.organization_id != organization_id do
      raise Ecto.NoResultsError, queryable: LabTest
    end

    lab_test
    |> LabTest.changeset(attrs)
    |> Repo.update()
  end

  @doc "Returns a changeset for the given lab test."
  def change_lab_test(%LabTest{} = lab_test, attrs \\ %{}) do
    LabTest.changeset(lab_test, attrs)
  end

  @doc "Lists active (is_active: true) lab tests for an organization, ordered by category then name."
  def list_active_lab_tests(organization_id) do
    Repo.all(
      from t in LabTest,
        where: t.organization_id == ^organization_id and t.is_active == true,
        order_by: [asc: t.category, asc: t.name]
    )
  end
end
