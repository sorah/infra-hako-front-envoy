#!/bin/bash
ENVOY_OPTS="-c /config.yml"

if [[ -n "${ENVOY_CONCURRENCY}" ]]; then
  ENVOY_OPTS="${ENVOY_OPTS} --concurrency ${ENVOY_CONCURRENCY}"
fi
sed -i -e "s/||ADDRESS||/${ADDRESS:-app}/g" /config.yml
sed -i -e "s/||PORT||/${PORT:-8080}/g" /config.yml
exec envoy $ENVOY_OPTS
