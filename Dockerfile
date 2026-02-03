FROM debian:13.3-slim  AS fetcher

ARG platform=aarch64

RUN apt-get update && apt-get install -y wget curl jq unzip

WORKDIR /

# 1. Copy the AIRCAST_URL file into the build context
COPY AIRCAST_URL /AIRCAST_URL

# 2. Read the URL from the file and proceed with the download
RUN AIRCAST_URL=$(cat /AIRCAST_URL | tr -d '\n\r') \
     && mkdir ./aircast \
     && wget -O aircast.zip "$AIRCAST_URL" \
     && unzip aircast.zip -d ./aircast \
     && rm aircast.zip \
     && mv ./aircast/aircast-linux-${platform} aircast-server \
     && chmod +x aircast-server

FROM debian:13.3-slim 
RUN  apt-get update && apt-get install -y libssl3 libssl-dev \
     && rm -rf /var/lib/apt/lists/*


WORKDIR /

COPY --from=fetcher /aircast-server /aircast-server

ENTRYPOINT [ "./aircast-server" ]
CMD [ "-Z" ]
