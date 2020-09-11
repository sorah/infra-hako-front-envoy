#!/bin/bash
ENVOY_OPTS="-c /work/config.yaml"



if [[ -n "${ENVOY_CONCURRENCY}" ]]; then
  ENVOY_OPTS="${ENVOY_OPTS} --concurrency ${ENVOY_CONCURRENCY}"
fi
cp /config.yml /work/config.yaml
sed -i -e "s/||ADDRESS||/${ADDRESS:-app}/g" /work/config.yaml
sed -i -e "s/||PORT||/${PORT:-8080}/g" /work/config.yaml

if [[ -n "${TLS}" ]]; then
  openssl req -x509 -nodes -days 3650 -newkey ec:<(openssl ecparam -name prime256v1) -keyout /work/tls.key -out /work/tls.crt -subj "/CN=$(hostname).invalid/"
  tls_config='transport_socket: {"name": "envoy.transport_sockets.tls", "typed_config": {"@type": "type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.DownstreamTlsContext", "common_tls_context": {"alpn_protocols": ["h2","http/1.1"], "tls_params": {"tls_minimum_protocol_version": "TLSv1_2"}, "tls_certificates": [{"certificate_chain": {"filename":  "/work/tls.crt"}, "private_key": {"filename": "/work/tls.key"}}]}}}'
  sed -i -e "s|//TLS//|${tls_config}|g" /work/config.yaml
else
  sed -i -e "s|//TLS//||g" /work/config.yaml
fi

if [[ -n "${HTTP2}" ]]; then
  sed -i -e "s/||HTTP2||/http2_protocol_options: {max_concurrent_streams: ${HTTP2_MAX_CONCURRENT_STREAMS:-2147483647}}/g" /work/config.yaml
else
  sed -i -e "s/||HTTP2||//g" /work/config.yaml
fi
echo "===="
cat /work/config.yaml
echo "===="
exec envoy $ENVOY_OPTS
