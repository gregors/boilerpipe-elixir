FROM elixir:1.7.4-slim

RUN apt-get update -yqq &&  apt-get install -yqq --no-install-recommends \
  git

COPY config /usr/src/app/
COPY mix.exs /usr/src/app/

WORKDIR /usr/src/app

RUN mix
COPY . /usr/src/app/

CMD ["mix", "test"]
