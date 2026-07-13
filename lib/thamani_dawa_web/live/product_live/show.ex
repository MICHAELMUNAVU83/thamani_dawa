defmodule ThamaniDawaWeb.ProductLive.Show do
  use ThamaniDawaWeb, :live_view

  alias ThamaniDawa.Batches
  alias ThamaniDawa.Batches.Batch
  alias ThamaniDawa.Products
  alias ThamaniDawa.Sites

  def mount(%{"id" => id}, _session, socket) do
    organization_id = socket.assigns.current_scope.organization_id
    product = Products.get_product!(organization_id, id)

    batches =
      organization_id
      |> Batches.list_batches()
      |> Enum.filter(&(&1.product_id == product.id))

    {:ok,
     socket
     |> assign(:product, product)
     |> assign(:sites, Sites.list_sites(organization_id))
     |> stream(:batches, batches)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action)}
  end

  defp apply_action(socket, :show) do
    assign(socket, :form, nil)
  end

  defp apply_action(socket, :new_batch) do
    changeset = Batch.changeset(%Batch{}, %{gtin: socket.assigns.product.gtin})
    assign(socket, :form, to_form(changeset, as: :batch))
  end

  def handle_event("validate", %{"batch" => attrs}, socket) do
    changeset =
      %Batch{}
      |> Batch.changeset(attrs)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :batch))}
  end

  def handle_event("save", %{"batch" => attrs}, socket) do
    scope = socket.assigns.current_scope
    product = socket.assigns.product

    attrs =
      attrs
      |> Map.put("product_id", product.id)
      |> Map.put("approver_id", scope.user.id)
      |> Map.put("received_by_id", scope.user.id)
      |> Map.put("received_at", DateTime.utc_now())

    case Batches.create_batch(scope.organization_id, attrs) do
      {:ok, batch} ->
        {:noreply,
         socket
         |> put_flash(:info, "Batch added.")
         |> stream_insert(:batches, batch)
         |> push_patch(to: ~p"/org/products/#{product.id}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset, as: :batch))}
    end
  end

  defp product_name(product), do: product.generic_name || product.brand_name || "(unnamed)"

  def render(assigns) do
    ~H"""
    <Layouts.org_shell flash={@flash} current_scope={@current_scope} current_path={~p"/org/products"}>
      <.header>
        {product_name(@product)}
        <:actions>
          <.button
            :if={@live_action == :show}
            variant="primary"
            patch={~p"/org/products/#{@product.id}/batches/new"}
          >
            + Add batch
          </.button>
          <.button variant="ghost-edit" navigate={~p"/org/products/#{@product.id}/edit"}>Edit</.button>
          <.button navigate={~p"/org/products"}>Back</.button>
        </:actions>
      </.header>

      <div :if={@live_action == :new_batch} class="card bg-base-200 mb-6">
        <div class="card-body">
          <h2 class="font-semibold mb-2">Add batch</h2>
          <.form for={@form} id="batch-form" phx-submit="save" phx-change="validate">
            <div class="grid grid-cols-2 gap-x-4">
              <.input
                field={@form[:site_id]}
                type="select"
                label="Site"
                options={Enum.map(@sites, &{&1.name, &1.id})}
                prompt="Choose a site"
                required
              />
              <.input field={@form[:gtin]} label="GTIN" required />
              <.input field={@form[:batch_no]} label="Batch / lot number" required />
              <.input field={@form[:expiry_date]} type="date" label="Expiry date" required />
              <.input field={@form[:quantity]} type="number" label="Quantity" required />
              <.input field={@form[:cost_per_unit]} type="number" label="Cost per unit" step="0.01" />
            </div>
            <div class="flex gap-2 mt-2">
              <.button variant="primary">Save</.button>
              <.button patch={~p"/org/products/#{@product.id}"}>Cancel</.button>
            </div>
          </.form>
        </div>
      </div>

      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 py-4 border-b border-base-200 text-sm mb-6">
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">Brand</div>
          <div class="font-medium">{@product.brand_name || "—"}</div>
        </div>
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">Category</div>
          <div class="font-medium">{@product.category || "—"}</div>
        </div>
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">Unit</div>
          <div class="font-medium">{@product.uom || "—"}</div>
        </div>
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">GTIN</div>
          <div class="font-medium font-mono">{@product.gtin || "—"}</div>
        </div>
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">Price</div>
          <div class="font-medium">{@product.price}</div>
        </div>
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">Reorder level</div>
          <div class="font-medium">{@product.reorder_level || "—"}</div>
        </div>
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">OTC</div>
          <div class="font-medium">{if @product.is_otc, do: "Yes", else: "No"}</div>
        </div>
        <div>
          <div class="text-xs uppercase tracking-wide opacity-50 mb-1">Dangerous drug</div>
          <div class="font-medium">{if @product.is_dangerous_drug, do: "Yes", else: "No"}</div>
        </div>
      </div>

      <.header>
        Batches
        <:actions>
          <.button
            :if={@live_action == :show}
            variant="primary"
            patch={~p"/org/products/#{@product.id}/batches/new"}
          >
            + Add batch
          </.button>
        </:actions>
      </.header>
      <.table id="batches" rows={@streams.batches}>
        <:col :let={{_id, batch}} label="Batch no.">{batch.batch_no}</:col>
        <:col :let={{_id, batch}} label="Expiry">{batch.expiry_date}</:col>
        <:col :let={{_id, batch}} label="Remaining">{batch.remaining_quantity}</:col>
      </.table>
    </Layouts.org_shell>
    """
  end
end
