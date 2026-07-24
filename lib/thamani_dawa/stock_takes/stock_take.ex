defmodule ThamaniDawa.StockTakes.StockTake do
  use Ecto.Schema
  import Ecto.Changeset

  alias ThamaniDawa.Accounts.User
  alias ThamaniDawa.Organizations.Organization
  alias ThamaniDawa.Sites.Site
  alias ThamaniDawa.StockTakes.StockTakeItem

  schema "stock_takes" do
    field :status, Ecto.Enum, values: [:draft, :finalized], default: :draft
    field :notes, :string
    field :finalized_at, :utc_datetime

    belongs_to :organization, Organization
    belongs_to :site, Site
    belongs_to :started_by, User, foreign_key: :started_by_id
    belongs_to :finalized_by, User, foreign_key: :finalized_by_id
    has_many :items, StockTakeItem, foreign_key: :stock_take_id

    timestamps()
  end

  @doc "Changeset for creating a new draft stock take."
  def changeset(stock_take, attrs) do
    stock_take
    |> cast(attrs, [:site_id, :started_by_id, :notes])
    |> validate_required([:site_id, :started_by_id])
  end

  @doc "Changeset applied when a draft is finalized."
  def finalize_changeset(stock_take, attrs) do
    stock_take
    |> cast(attrs, [:finalized_by_id, :finalized_at])
    |> validate_required([:finalized_by_id, :finalized_at])
    |> put_change(:status, :finalized)
  end
end
