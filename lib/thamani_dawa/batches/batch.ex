defmodule ThamaniDawa.Batches.Batch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "batches" do
    field :organization_id, :id
    field :product_id, :id
    field :site_id, :id
    field :gtin, :string
    field :batch_no, :string
    field :serial, :string
    field :manufacture_date, :date
    field :expiry_date, :date
    field :quantity, :integer
    field :remaining_quantity, :integer
    field :cost_per_unit, :decimal
    field :supplier_id, :id
    field :received_by_id, :id
    field :received_at, :utc_datetime
    field :is_approved, :boolean, default: false
    field :approver_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(batch, attrs) do
    batch
    |> cast(attrs, [
      :product_id,
      :site_id,
      :gtin,
      :batch_no,
      :serial,
      :manufacture_date,
      :expiry_date,
      :quantity,
      :remaining_quantity,
      :cost_per_unit,
      :supplier_id,
      :received_by_id,
      :received_at,
      :is_approved,
      :approver_id
    ])
    |> validate_required([
      :product_id,
      :site_id,
      :gtin,
      :batch_no,
      :expiry_date,
      :quantity,
      :approver_id
    ])
    |> ThamaniDawa.Gtin.validate_gtin()
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_number(:remaining_quantity, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:site_id)
    |> foreign_key_constraint(:supplier_id)
    |> foreign_key_constraint(:received_by_id)
    |> foreign_key_constraint(:approver_id)
  end
end
