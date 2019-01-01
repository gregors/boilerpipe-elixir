FROM elixir:1.7.4-slim

RUN apt-get update -yqq &&  apt-get install -yqq --no-install-recommends \
  git

COPY . /usr/src/app/

WORKDIR /usr/src/app

RUN mix

CMD ["mix", "test"]
