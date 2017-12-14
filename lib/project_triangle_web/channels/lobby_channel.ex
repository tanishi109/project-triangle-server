defmodule ProjectTriangleWeb.LobbyChannel do
  use Phoenix.Channel
  alias ProjectTriangleWeb.LobbyRegistry

  def join("lobby", %{"id" => id}, socket) do
    LobbyRegistry.update(id)

    socket = assign(socket, :me, id)

    {:ok, socket}
  end

  def terminate(reason, socket) do
    IO.puts("> leave #{inspect reason}")
    IO.inspect(socket.assigns[:me])

    # TODO: ここでユーザーの削除をpubする
    # Registry.dispatch(ProjectTriangleWeb.RoomPub, "foo", fn entries ->
    #   for {pid, _} <- entries, do: GenServer.cast(pid, {:broadcast, "save", id})
    # end)

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
