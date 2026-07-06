defmodule ThamaniDawa.ProductsFixtures do
  @moduledoc """
  Test helpers for creating entities via `ThamaniDawa.Products`.
  """

  alias ThamaniDawa.OrganizationsFixtures
  alias ThamaniDawa.Products
  alias ThamaniDawa.SitesFixtures

  def valid_product_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      generic_name: "Paracetamol #{System.unique_integer()}",
      uom: "tablet",
      price: 100
    })
  end

  @doc "Creates a product under a fresh organization unless `organization_id` is given."
  def product_fixture(attrs \\ %{}) do
    {organization_id, attrs} =
      Map.pop_lazy(attrs, :organization_id, fn ->
        OrganizationsFixtures.organization_fixture().id
      end)

    {site_id, attrs} =
      Map.pop_lazy(attrs, :site_id, fn ->
        SitesFixtures.site_fixture(%{organization_id: organization_id}).id
      end)

    attrs = Map.put(attrs, :site_id, site_id)

    {:ok, product} =
      attrs
      |> valid_product_attributes()
      |> then(&Products.create_product(organization_id, &1))

    product
  end
end
