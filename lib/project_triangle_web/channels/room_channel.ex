defmodule ProjectTriangleWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> roomkey, %{"id" => id}, socket) do
    IO.inspect("#{id} joined #{roomkey} room!")
    
    {:ok, socket}
  end

  def handle_in("input", %{"key_map" => key_map, "id" => id}, socket) do

    broadcast!(socket, "tick", %{
      key_map: key_map,
      id: id,
    })

    {:noreply, socket}
  end
end
