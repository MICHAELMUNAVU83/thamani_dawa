defmodule ThamaniDawaWeb.ProductLive.Show do
  use ThamaniDawaWeb, :live_view

  alias ThamaniDawa.Batches
  alias ThamaniDawa.Products

  def mount(%{"id" => id}, _session, socket) do
    organization_id = socket.assigns.current_scope.organization_id
    product = Products.get_product!(organization_id, id)

    batches =
      organization_id
      |> Batches.list_batches()
      |> Enum.filter(&(&1.product_id == product.id))

    {:ok, assign(socket, product: product, batches: batches, base_path: base_path(socket))}
  end

  defp base_path(socket) do
    if socket.assigns.current_scope.user.role == :lab_technician,
      do: "/lab/products",
      else: "/pharmacy/products"
  end

  defp product_name(product), do: product.generic_name || product.brand_name || "(unnamed)"

  def render(assigns) do
    ~H"""
    <%= if @current_scope.user.role == :lab_technician do %>
      <Layouts.lab_shell flash={@flash} current_scope={@current_scope} current_path={@base_path}>
        <.product_content {assigns} />
      </Layouts.lab_shell>
    <% else %>
      <Layouts.app_shell flash={@flash} current_scope={@current_scope}>
        <.product_content {assigns} />
      </Layouts.app_shell>
    <% end %>
    """
  end

  def product_content(assigns) do
    ~H"""
    <.header>
      {product_name(@product)}
      <:actions>
        <.button variant="ghost-edit" navigate={"#{@base_path}/#{@product.id}/edit"}>Edit</.button>
        <.button navigate={@base_path}>Back</.button>
      </:actions>
    </.header>

    <.list>
      <:item title="Brand name">{@product.brand_name}</:item>
      <:item title="Category">{@product.category}</:item>
      <:item title="Unit of measure">{@product.uom}</:item>
      <:item title="GTIN">{@product.gtin}</:item>
      <:item title="OTC">{if @product.is_otc, do: "Yes", else: "No"}</:item>
      <:item title="Dangerous drug">{if @product.is_dangerous_drug, do: "Yes", else: "No"}</:item>
      <:item title="Reorder level">{@product.reorder_level}</:item>
      <:item title="Price">{@product.price}</:item>
    </.list>

    <.header class="mt-6">Batches</.header>
    <.table id="batches" rows={@batches}>
      <:col :let={batch} label="Batch no.">{batch.batch_no}</:col>
      <:col :let={batch} label="Expiry">{batch.expiry_date}</:col>
      <:col :let={batch} label="Remaining">{batch.remaining_quantity}</:col>
    </.table>
    """
  end
end
