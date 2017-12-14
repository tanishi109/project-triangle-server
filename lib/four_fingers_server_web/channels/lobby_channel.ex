defmodule ProjectTriangleWeb.LobbyChannel do
  use Phoenix.Channel
  alias ProjectTriangleWeb.RoomSub

  def join("lobby", %{"id" => id}, socket) do
    Registry.dispatch(ProjectTriangleWeb.RoomPub, "foo", fn entries ->
      for {pid, _} <- entries, do: GenServer.cast(pid, {:broadcast, "save", id})
    end)

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

  # def handle_info(:after_join, socket) do
  #   user_ids = RoomSub.get_agent_val()
    
  #   Enum.map(user_ids, fn user_id ->
  #     IO.inspect("id = #{user_id}")
  #     if (user_id !== id) do
  #       IO.inspect("id #{id} has match with #{user_id}!!")
  #       socket = assign(socket, :users, "id")
  #       broadcast!(socket, "matched", %{})
  #     end
  #   end)

  #   {:noreply, socket}
  # end
  # def join("room:" <> _private_room_id, _params, _socket) do
  #   {:error, %{reason: "unauthorized"}}
  # end

  # def handle_info("invite:" <> id, state) do
  #   IO.inspect("*** id #{id} is invited!")
  #   {:noreply, state}
  # end

  def handle_in("request_match", %{"id" => id}, socket) do
    user_ids = RoomSub.get_agent_val()
    Enum.map(user_ids, fn user_id ->
      IO.inspect("id = #{user_id}")
      if (user_id !== id) do
        IO.inspect("id #{id} has match with #{user_id}!!")
        key = "some_uniq_key"
        roomkey_map = %{}
        |> Map.put(user_id, key)
        |> Map.put(id, key)
        broadcast!(socket, "matched", %{roomkey_map: roomkey_map})
      end
    end)

    {:noreply, socket}
  end

  def handle_in("invited:" <> id, _, socket) do
    IO.inspect("*** id #{id} invited!!")

    {:noreply, socket}
  end
end
