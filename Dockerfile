FROM library/elixir

ADD . /tmp/workspace/four_fingers_server
WORKDIR /tmp/workspace/four_fingers_server

RUN rm -rf deps
RUN rm -rf _build
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

ENTRYPOINT mix ecto.create && mix ecto.migrate && mix phx.server
