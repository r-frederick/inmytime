FROM bitwalker/alpine-elixir

COPY . /app
WORKDIR /app
RUN mix deps.get --force
ENV MIX_ENV prod

RUN mix release

ENV PORT 8080
CMD ["_build/prod/rel/inmytime/bin/inmytime", "foreground"]