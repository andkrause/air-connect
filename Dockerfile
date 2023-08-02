FROM debian:12.1-slim  AS fetcher

ARG platform=aarch64

RUN apt-get update && apt-get install -y wget 

WORKDIR /

RUN wget -O aircast-server https://github.com/philippe44/AirConnect/blob/master/bin/aircast-linux-${platform}?raw=true \
     && chmod +x aircast-server

FROM debian:12.1-slim 
RUN  apt-get update && apt-get install -y libssl3 libssl-dev \
     && rm -rf /var/lib/apt/lists/*


WORKDIR /

COPY --from=fetcher /aircast-server /aircast-server

ENTRYPOINT [ "./aircast-server" ]
CMD [ "-Z" ]
