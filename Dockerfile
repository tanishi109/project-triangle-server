FROM library/elixir

RUN apt-get -qq update
RUN apt-get -qq install inotify-tools

ADD . /tmp/workspace/project_triangle
WORKDIR /tmp/workspace/project_triangle

RUN rm -rf deps
RUN rm -rf _build
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

ENTRYPOINT mix ecto.create && mix ecto.migrate && iex -S mix phx.server
