defmodule ThamaniDawaWeb.LabDashboardLive do
  use ThamaniDawaWeb, :live_view

  alias ThamaniDawa.LabOrders
  alias ThamaniDawaWeb.SiteScoping

  def mount(_params, _session, socket) do
    scope = socket.assigns.current_scope
    organization_id = scope.organization_id

    lab_orders =
      organization_id
      |> LabOrders.list_lab_orders_with_patient()
      |> SiteScoping.for_current_site(scope)

    {:ok,
     socket
     |> assign(:pending, Enum.filter(lab_orders, &(&1.status == :pending)))
     |> assign(:incomplete, Enum.filter(lab_orders, &(&1.status in [:pending, :in_progress])))}
  end

  defp patient_name(%{patient_visit: %{patient: patient}}) when not is_nil(patient),
    do: patient.full_name

  defp patient_name(_lab_order), do: "(unknown patient)"

  def render(assigns) do
    ~H"""
    <Layouts.lab_shell flash={@flash} current_scope={@current_scope} current_path="/lab">
      <.header>Lab dashboard</.header>

      <.header class="mt-4">Pending orders</.header>
      <.table
        id="pending-orders"
        rows={@pending}
        row_click={fn o -> JS.navigate(~p"/lab/orders/#{o.id}") end}
      >
        <:col :let={lab_order} label="Patient">{patient_name(lab_order)}</:col>
        <:col :let={lab_order} label="Urgency">{lab_order.urgency}</:col>
        <:col :let={lab_order} label="Created">{lab_order.inserted_at}</:col>
      </.table>

      <.header class="mt-6">Incomplete reports</.header>
      <.table
        id="incomplete-orders"
        rows={@incomplete}
        row_click={fn o -> JS.navigate(~p"/lab/orders/#{o.id}") end}
      >
        <:col :let={lab_order} label="Patient">{patient_name(lab_order)}</:col>
        <:col :let={lab_order} label="Status">{Phoenix.Naming.humanize(lab_order.status)}</:col>
        <:col :let={lab_order} label="Created">{lab_order.inserted_at}</:col>
      </.table>
    </Layouts.lab_shell>
    """
  end
end
