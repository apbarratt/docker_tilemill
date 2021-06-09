# Using my own ubuntu image for this, which is just the official one plus carbon, git, etc.
FROM apbarratt/ubuntu-18-with-node-carbon

# Install tilemill
RUN git clone https://github.com/tilemill-project/tilemill.git
WORKDIR /tilemill
RUN npm install

# Clean up
RUN npm cache clean --force

# Set the default hostname
ENV TILEMILL_HOST=127.0.0.1
ENV TILEMILL_PORT="NO_PROXY"

# Start tilemill, making sure the interface renders with different ports where required by a proxy.
ENTRYPOINT  /bin/bash -c "\
            if [[ $TILEMILL_PORT = "NO_PROXY" ]]; then \
             node ./index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST}:20009 --tileUrl=${TILEMILL_HOST}:20008; \
            elif [[ "$TILEMILL_PORT" = 80 ]]; then \
              node ./index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST} --tileUrl=${TILEMILL_HOST}/tiles; \
            else \
              node ./index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST}:${TILEMILL_PORT} --tileUrl=${TILEMILL_HOST}:${TILEMILL_PORT}/tiles; \
            fi; \
            "

# Expose ports for tilemill
EXPOSE 20009
EXPOSE 20008