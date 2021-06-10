# Using my own ubuntu image for this, which is just the official one plus carbon, git, etc.
FROM apbarratt/ubuntu-18-with-node-carbon

# We'll just stick that fix to the mesg nonsense docker ubuntu does in here
RUN sed -i ~/.profile -e 's/mesg n || true/tty -s \&\& mesg n/g'

# And make sure we're using the right shell
SHELL ["/bin/bash", "-l", "-c"]

# Install tilemill
RUN git clone https://github.com/tilemill-project/tilemill.git
WORKDIR /tilemill
RUN npm install

# Clean up
RUN npm cache clean --force

# Set up the shell so we can easily use the mapnik binaries should we want to later
RUN ln -s /tilemill/node_modules/mapnik/lib/binding/bin/shapeindex /usr/local/bin/ && \
    ln -s /tilemill/node_modules/mapnik/lib/binding/bin/mapnik-index /usr/local/bin

# Set the default hostname
ENV TILEMILL_HOST=127.0.0.1
ENV TILEMILL_PORT="NO_PROXY"

# Start tilemill, making sure the interface renders with different ports where required by a proxy.
ENTRYPOINT  /bin/bash -c "\
            if [[ $TILEMILL_PORT = "NO_PROXY" ]]; then \
             node /tilemill/index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST}:20009 --tileUrl=${TILEMILL_HOST}:20008; \
            elif [[ "$TILEMILL_PORT" = 80 ]]; then \
              node /tilemill/index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST} --tileUrl=${TILEMILL_HOST}/tiles; \
            else \
              node /tilemill/index.js --server=true --listenHost=0.0.0.0 --coreUrl=${TILEMILL_HOST}:${TILEMILL_PORT} --tileUrl=${TILEMILL_HOST}:${TILEMILL_PORT}/tiles; \
            fi; \
            "

# Expose ports for tilemill
EXPOSE 20009
EXPOSE 20008