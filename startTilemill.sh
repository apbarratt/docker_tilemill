# Start tilemill, making sure the interface renders with different ports where required by a proxy.
if [[ $TILEMILL_PORT = "NO_PROXY" ]]; then
  echo "Starting tilemill with default urls of ${TILEMILL_HOST}:20009 for the interface and ${TILEMILL_HOST}:20008 for tiles."
  node /tilemill/index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST}:20009 --tileUrl=${TILEMILL_HOST}:20008;
elif [[ "$TILEMILL_PORT" = 80 ]]; then
  echo "Starting tilemill urls of ${TILEMILL_HOST} for the interface and ${TILEMILL_HOST}/tiles for tiles."
  node /tilemill/index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST} --tileUrl=${TILEMILL_HOST}/tiles;
else
  echo "Starting tilemill urls of ${TILEMILL_HOST}:${TILEMILL_PORT} for the interface and ${TILEMILL_HOST}:${TILEMILL_PORT}/tiles for tiles."
  node /tilemill/index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST}:${TILEMILL_PORT} --tileUrl=${TILEMILL_HOST}:${TILEMILL_PORT}/tiles;
fi;