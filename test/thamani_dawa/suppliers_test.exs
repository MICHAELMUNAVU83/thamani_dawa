defmodule ThamaniDawa.SuppliersTest do
  use ThamaniDawa.DataCase, async: true

  alias ThamaniDawa.Suppliers
  alias ThamaniDawa.Suppliers.Supplier

  import ThamaniDawa.OrganizationsFixtures
  import ThamaniDawa.SuppliersFixtures

  describe "create_supplier/2" do
    test "requires a name" do
      organization = organization_fixture()
      assert {:error, changeset} = Suppliers.create_supplier(organization.id, %{})
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "creates a supplier scoped to the organization" do
      organization = organization_fixture()

      assert {:ok, %Supplier{} = supplier} =
               Suppliers.create_supplier(organization.id, %{
                 name: "Acme Distributors",
                 phone: "0700000000",
                 email: "orders@acme.test"
               })

      assert supplier.organization_id == organization.id
      assert supplier.name == "Acme Distributors"
      assert supplier.is_active
    end

    test "allows the same supplier name across organizations" do
      organization_a = organization_fixture()
      organization_b = organization_fixture()

      attrs = %{name: "Acme Distributors", phone: "+254700000000", email: "acme@example.com"}

      assert {:ok, _} = Suppliers.create_supplier(organization_a.id, attrs)
      assert {:ok, _} = Suppliers.create_supplier(organization_b.id, attrs)
    end

    test "requires phone and email" do
      organization = organization_fixture()

      assert {:error, changeset} =
               Suppliers.create_supplier(organization.id, %{name: "Acme Distributors"})

      assert %{phone: ["can't be blank"], email: ["can't be blank"]} = errors_on(changeset)
    end

    test "rejects a malformed email" do
      organization = organization_fixture()

      assert {:error, changeset} =
               Suppliers.create_supplier(organization.id, %{
                 name: "Acme Distributors",
                 phone: "+254700000000",
                 email: "not-an-email"
               })

      assert %{email: ["Please enter a valid email (e.g. you@example.com)"]} =
               errors_on(changeset)
    end
  end

  describe "list_suppliers/1" do
    test "only returns suppliers for the given organization" do
      organization_a = organization_fixture()
      organization_b = organization_fixture()

      supplier_a = supplier_fixture(%{organization_id: organization_a.id})
      supplier_fixture(%{organization_id: organization_b.id})

      assert [%Supplier{id: id}] = Suppliers.list_suppliers(organization_a.id)
      assert id == supplier_a.id
    end
  end

  describe "get_supplier!/2" do
    test "raises when the supplier belongs to a different organization" do
      other_organization = organization_fixture()
      supplier = supplier_fixture()

      assert_raise Ecto.NoResultsError, fn ->
        Suppliers.get_supplier!(other_organization.id, supplier.id)
      end
    end
  end

  describe "update_supplier/2" do
    test "updates the given fields" do
      supplier = supplier_fixture(%{name: "Old Name"})

      assert {:ok, updated} = Suppliers.update_supplier(supplier, %{name: "New Name"})
      assert updated.name == "New Name"
    end

    test "toggles is_active" do
      supplier = supplier_fixture()
      assert supplier.is_active

      assert {:ok, updated} = Suppliers.update_supplier(supplier, %{is_active: false})
      refute updated.is_active
    end

    test "returns an error changeset for an invalid update" do
      supplier = supplier_fixture()

      assert {:error, changeset} = Suppliers.update_supplier(supplier, %{email: "not-an-email"})

      assert %{email: ["Please enter a valid email (e.g. you@example.com)"]} =
               errors_on(changeset)
    end
  end

  describe "change_supplier/2" do
    test "returns a changeset pre-populated with the supplier's current data" do
      supplier = supplier_fixture(%{name: "Acme Distributors"})

      changeset = Suppliers.change_supplier(supplier)

      assert changeset.data.name == "Acme Distributors"
      assert changeset.valid?
    end
  end
end
