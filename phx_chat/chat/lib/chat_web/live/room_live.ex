defmodule ChatWeb.RoomLive do
  use ChatWeb, :live_view
  import Phoenix.LiveView
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:#{room_id}"
    if connected?(socket), do: ChatWeb.Endpoint.subscribe(topic)

    {:ok,
     assign(socket,
       room_id: room_id,
       topic: topic,
       messages: ["Hello Phoenix!", "Kaboom!"],
       temporary_assigns: [messages: []]
     )}
  end

  @impl true
  def handle_event("submit-message", %{"chat" => %{"message" => msg}}, socket) do
    Logger.info(message: msg)
    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", msg)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: msg}, socket) do
    {:noreply, assign(socket, messages: [msg])}
  end
end
