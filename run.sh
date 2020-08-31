#!/bin/bash
ENVOY_OPTS="-c /config.gen.yml"

if [[ -n "${ENVOY_CONCURRENCY}" ]]; then
  ENVOY_OPTS="${ENVOY_OPTS} --concurrency ${ENVOY_CONCURRENCY}"
fi
cp /config.yml /config.gen.yml
sed -i -e "s/||ADDRESS||/${ADDRESS:-app}/g" /config.gen.yml
sed -i -e "s/||PORT||/${PORT:-8080}/g" /config.gen.yml
exec envoy $ENVOY_OPTS
