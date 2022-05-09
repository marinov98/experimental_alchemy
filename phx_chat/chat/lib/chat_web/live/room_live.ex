defmodule ChatWeb.RoomLive do
  use ChatWeb, :live_view
  import Phoenix.LiveView
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:#{room_id}"
    username = MnemonicSlugs.generate_slug(2)

    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic)
      ChatWeb.Presence.track(self(), topic, username, %{})
    end

    {:ok,
     assign(socket,
       room_id: room_id,
       topic: topic,
       username: username,
       user_list: [],
       message: "",
       messages: [
         %{uuid: UUID.uuid4(), content: "#{username} joined the chat", username: "system"}
       ],
       temporary_assigns: [messages: []]
     )}
  end

  @impl true
  def handle_event("submit-message", %{"chat" => %{"message" => msg}}, socket) do
    msg = %{uuid: UUID.uuid4(), content: msg, username: socket.assigns.username}
    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", msg)
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => msg}}, socket) do
    {:noreply, assign(socket, message: msg)}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: msg}, socket) do
    {:noreply, assign(socket, messages: [msg])}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username ->
        %{type: :system, uuid: UUID.uuid4(), content: "#{username} joined"}
      end)

    leave_messages =
      leaves
      |> Map.keys()
      |> Enum.map(fn username ->
        %{type: :system, uuid: UUID.uuid4(), content: "#{username} left"}
      end)

    user_list = ChatWeb.Presence.list(socket.assigns.topic) |> Map.keys()

    {:noreply, assign(socket, messages: join_messages ++ leave_messages, user_list: user_list)}
  end

  def display_message(%{type: :system, uuid: uuid, content: content}) do
    ~E"""
      <p id="<%= uuid %>"><em><%= content %></em></p>
    """
  end

  def display_message(%{uuid: uuid, content: content, username: username}) do
    ~E"""
      <p id="<%= uuid %>"><strong><%= username %></strong>: <%= content %> </p>
    """
  end
end
