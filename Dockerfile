FROM debian:buster-slim AS fetcher

ARG platform=aarch64

RUN apt-get update && apt-get install -y wget 

WORKDIR /

RUN wget -O aircast-server https://github.com/philippe44/AirConnect/blob/master/bin/aircast-${platform}?raw=true \
     && chmod +x aircast-server

FROM debian:buster-slim

WORKDIR /

COPY --from=fetcher /aircast-server /aircast-server

ENTRYPOINT [ "./aircast-server" ]