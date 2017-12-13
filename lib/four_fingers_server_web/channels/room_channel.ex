defmodule FourFingersServerWeb.RoomChannel do
  use Phoenix.Channel
  alias FourFingersServerWeb.RoomSub

  def join("lobby", %{"id" => id}, socket) do
    Registry.dispatch(FourFingersServerWeb.RoomPub, "foo", fn entries ->
      for {pid, _} <- entries, do: GenServer.cast(pid, {:broadcast, "save", id})
    end)

    {:ok, socket}
  end

  def terminate(reason, _socket) do
    IO.puts("> leave #{inspect reason}")
    # TODO: ここでユーザーの削除をpubする
    # socket にアサインしておくか、
    # socket.channel_pidのmapを作っておく
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
        broadcast!(socket, "matched", %{users: [user_id, id]})
      end
    end)

    {:noreply, socket}
  end

  def handle_in("invited:" <> id, _, socket) do
    IO.inspect("*** id #{id} invited!!")

    {:noreply, socket}
  end
end
