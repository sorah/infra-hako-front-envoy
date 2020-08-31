FROM envoyproxy/envoy:v1.15-latest

# for fault injection
RUN mkdir -p /srv/runtime/current/envoy
RUN mkdir -p /srv/runtime/current/envoy_override
RUN mkdir -p /work
RUN chown envoy /work

COPY run.sh /run.sh
COPY config.yml /config.yml

CMD ["/run.sh"]
