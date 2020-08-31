#!/bin/bash
ENVOY_OPTS="-c /work/config.yaml"

if [[ -n "${ENVOY_CONCURRENCY}" ]]; then
  ENVOY_OPTS="${ENVOY_OPTS} --concurrency ${ENVOY_CONCURRENCY}"
fi
cp /config.yml /work/config.yaml
sed -i -e "s/||ADDRESS||/${ADDRESS:-app}/g" /work/config.yaml
sed -i -e "s/||PORT||/${PORT:-8080}/g" /work/config.yaml
if [[ -n "${HTTP2}" ]]; then
  sed -i -e "s/||HTTP2||/http2_protocol_options: {}/g" /work/config.yaml
else
  sed -i -e "s/||HTTP2||//g" /work/config.yaml
fi
exec envoy $ENVOY_OPTS
