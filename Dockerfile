FROM debian:11.2-slim  AS fetcher

ARG platform=aarch64

RUN apt-get update && apt-get install -y wget 

WORKDIR /

RUN wget -O aircast-server https://github.com/philippe44/AirConnect/blob/master/bin/aircast-${platform}?raw=true \
     && chmod +x aircast-server

FROM debian:11.2-slim 
RUN  apt-get update && apt-get install -y libssl1.1 \
     && rm -rf /var/lib/apt/lists/*


WORKDIR /

COPY --from=fetcher /aircast-server /aircast-server

ENTRYPOINT [ "./aircast-server" ]