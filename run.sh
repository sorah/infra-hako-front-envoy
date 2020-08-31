#!/bin/bash
ENVOY_OPTS="-c /work/config.yaml"

if [[ -n "${ENVOY_CONCURRENCY}" ]]; then
  ENVOY_OPTS="${ENVOY_OPTS} --concurrency ${ENVOY_CONCURRENCY}"
fi
cp /config.yml /work/config.yaml
sed -i -e "s/||ADDRESS||/${ADDRESS:-app}/g" /work/config.yaml
sed -i -e "s/||PORT||/${PORT:-8080}/g" /work/config.yaml
exec envoy $ENVOY_OPTS
