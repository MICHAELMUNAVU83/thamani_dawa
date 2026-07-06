defmodule ThamaniDawa.PatientVisitsFixtures do
  @moduledoc """
  Test helpers for creating patient visit entities.
  """

  alias ThamaniDawa.AccountsFixtures
  alias ThamaniDawa.OrganizationsFixtures
  alias ThamaniDawa.PatientsFixtures
  alias ThamaniDawa.PatientVisits
  alias ThamaniDawa.SitesFixtures

  def valid_patient_visit_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{visit_type: :pharmacy})
  end

  @doc """
  Creates a patient visit under a fresh organization unless supporting ids are given.
  """
  def patient_visit_fixture(attrs \\ %{}) do
    {organization_id, attrs} =
      Map.pop_lazy(attrs, :organization_id, fn ->
        OrganizationsFixtures.organization_fixture().id
      end)

    {site_id, attrs} =
      Map.pop_lazy(attrs, :site_id, fn ->
        SitesFixtures.site_fixture(%{organization_id: organization_id}).id
      end)

    {patient_id, attrs} =
      Map.pop_lazy(attrs, :patient_id, fn ->
        PatientsFixtures.patient_fixture(%{organization_id: organization_id}).id
      end)

    {user_id, attrs} =
      Map.pop_lazy(attrs, :user_id, fn ->
        AccountsFixtures.staff_fixture(%{organization_id: organization_id}).id
      end)

    attrs =
      Map.merge(attrs, %{
        site_id: site_id,
        patient_id: patient_id,
        user_id: user_id
      })

    {:ok, patient_visit} =
      attrs
      |> valid_patient_visit_attributes()
      |> then(&PatientVisits.create_patient_visit(organization_id, &1))

    patient_visit
  end
end
