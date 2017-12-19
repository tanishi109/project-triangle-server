defmodule ProjectTriangleWeb.LobbyChannel do
  use Phoenix.Channel
  alias ProjectTriangleWeb.LobbyRegistry
  alias ProjectTriangleWeb.Helpers.Hash

  # id持ってない
  def join("lobby", %{"id" => id}, socket) when is_nil(id) do
    id = Hash.gen_random_str
    {:ok, %{id: id}, socket}
  end
  # id持ってる
  def join("lobby", %{"id" => id}, socket) do
    LobbyRegistry.update(id)

    socket = socket
    |> assign(:me, id)

    {:ok, socket}
  end

  def terminate(reason, socket) do
    my_id = socket.assigns[:me]
    LobbyRegistry.remove(my_id)

    :ok
  end

  def handle_in("request_match", %{"id" => id}, socket) do
    user_ids = LobbyRegistry.get()

    Enum.map(user_ids, fn user_id ->
      if (user_id !== id) do
        key = Hash.gen_random_str
        roomkey_map = %{}
        |> Map.put(user_id, key)
        |> Map.put(id, key)
        broadcast!(socket, "matched", %{roomkey_map: roomkey_map})
      end
    end)

    {:noreply, socket}
  end
end
