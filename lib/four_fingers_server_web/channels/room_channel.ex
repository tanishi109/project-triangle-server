defmodule FourFingersServerWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    Registry.dispatch(FourFingersServerWeb.RoomPub, "foo", fn entries ->
      for {pid, _} <- entries, do: GenServer.cast(pid, {:broadcast, "save", socket.channel_pid})
    end)

    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    {:noreply, socket}
  end
end
