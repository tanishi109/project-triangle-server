FROM postgres:9.6

FROM trenpixster/elixir

RUN apt-get -qq update

ADD . /tmp/workspace/project_triangle
WORKDIR /tmp/workspace/project_triangle

RUN rm -rf deps
RUN rm -rf _build
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

ENTRYPOINT mix ecto.create && mix ecto.migrate && mix phoenix.server

