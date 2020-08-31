FROM envoyproxy/envoy:v1.15-latest

COPY run.sh /run.sh
COPY config.yml /config.yml

# for fault injection
RUN mkdir -p /srv/runtime/current/envoy
RUN mkdir -p /srv/runtime/current/envoy_override

CMD ["/run.sh"]
