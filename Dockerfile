FROM rust:1.64.0-alpine3.16 as build

RUN apk add --no-cache musl-dev

WORKDIR /usr/src/cp-rust
RUN cargo init
COPY Cargo.toml Cargo.lock ./

RUN \
  cargo build --release && \
  rm -rf ./src

COPY src ./src/

RUN cargo install --path .

RUN which cp-rust

CMD ["cp-rust"]

FROM alpine:3.16.2

COPY --from=build /usr/local/cargo/bin/cp-rust /usr/bin/cp-rust

ENV RUST_LOG=debug
EXPOSE 3000

CMD ["cp-rust"]
