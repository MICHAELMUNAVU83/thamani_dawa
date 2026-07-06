defmodule ThamaniDawa.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :slug, :string
    field :license_number, :string
    field :is_active, :boolean, default: true
    field :is_subscription_active, :boolean, default: false
    field :kyc_details, :map, default: %{}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [
      :name,
      :slug,
      :license_number,
      :is_active,
      :is_subscription_active,
      :kyc_details
    ])
    |> validate_required([:name])
    |> unique_constraint(:slug)
  end
end
