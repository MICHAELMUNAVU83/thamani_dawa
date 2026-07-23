defmodule ThamaniDawaWeb.VerificationQueueLive do
  use ThamaniDawaWeb, :live_view

  alias ThamaniDawa.LabOrders

  def mount(_params, _session, socket) do
    {:ok, assign_queue(socket)}
  end

  def handle_event("verify", %{"id" => id}, socket) do
    scope = socket.assigns.current_scope
    result_id = String.to_integer(id)

    case LabOrders.verify_result(scope.organization_id, result_id, scope.user.id) do
      {:ok, _result} ->
        {:noreply,
         socket
         |> put_flash(:info, "Result verified.")
         |> assign_queue()}

      {:error, :cannot_self_verify} ->
        {:noreply, put_flash(socket, :error, "You cannot verify your own results.")}
    end
  end

  defp assign_queue(socket) do
    scope = socket.assigns.current_scope
    organization_id = scope.organization_id
    home_site_id = scope.user.site_id

    pending_verification =
      organization_id
      |> LabOrders.list_results_pending_verification()
      |> Enum.filter(&(is_nil(home_site_id) or &1.lab_order.site_id == home_site_id))

    assign(socket, :pending_verification, pending_verification)
  end

  defp patient_name(result) do
    case result.lab_order.patient_visit.patient do
      nil -> "—"
      patient -> patient.full_name
    end
  end

  defp test_name(result) do
    case result.lab_test do
      nil -> "(unknown test)"
      test -> test.name
    end
  end

  defp performer_name(result) do
    case result.performed_by do
      nil -> "—"
      user -> user.name
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.lab_shell
      flash={@flash}
      current_scope={@current_scope}
      current_path={~p"/lab/verification-queue"}
    >
      <.header>Results pending verification</.header>

      <.table id="verification-queue" rows={@pending_verification}>
        <:col :let={result} label="Patient">{patient_name(result)}</:col>
        <:col :let={result} label="Test">{test_name(result)}</:col>
        <:col :let={result} label="Performed by">{performer_name(result)}</:col>
        <:col :let={result} label="Performed on">{result.test_performed_on}</:col>
        <:action :let={result}>
          <button
            :if={result.performed_by_id != @current_scope.user.id}
            phx-click="verify"
            phx-value-id={result.id}
            class="text-sm font-semibold text-green-600 hover:text-green-800"
          >
            Verify
          </button>
        </:action>
      </.table>
    </Layouts.lab_shell>
    """
  end
end
