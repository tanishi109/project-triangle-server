defmodule ProjectTriangleWeb.LobbyChannel do
  use Phoenix.Channel
  alias ProjectTriangleWeb.LobbyRegistry
  alias ProjectTriangleWeb.Helpers.Hash

  def join("lobby", %{"id" => id}, socket) do
    LobbyRegistry.update(id)
    IO.inspect("*** Hash.get_random_token")
    IO.inspect(Hash.gen_random_token)

    socket = assign(socket, :me, id)

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
        key = "some_uniq_key"
        roomkey_map = %{}
        |> Map.put(user_id, key)
        |> Map.put(id, key)
        broadcast!(socket, "matched", %{roomkey_map: roomkey_map})
      end
    end)

    {:noreply, socket}
  end
end
