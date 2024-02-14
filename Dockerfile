FROM debian:12.5-slim  AS fetcher

ARG platform=aarch64

RUN apt-get update && apt-get install -y wget curl jq unzip

WORKDIR /

RUN AIRCAST_URL=$(curl -s https://api.github.com/repos/philippe44/AirConnect/releases/latest | jq -c -r '.assets[] | select(.name | test("AirConnect-\\d+\\.\\d+\\.\\d+\\.zip")).browser_download_url') \
     && mkdir ./aircast \
     && wget -O aircast.zip $AIRCAST_URL  \
     && unzip aircast.zip -d ./aircast \
     && rm aircast.zip \
     && mv ./aircast/aircast-linux-${platform} aircast-server \
     && chmod +x aircast-server 


FROM debian:12.5-slim 
RUN  apt-get update && apt-get install -y libssl3 libssl-dev \
     && rm -rf /var/lib/apt/lists/*


WORKDIR /

COPY --from=fetcher /aircast-server /aircast-server

ENTRYPOINT [ "./aircast-server" ]
CMD [ "-Z" ]
