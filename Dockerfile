# Using my own ubuntu image for this, which is just the official one plus carbon, git, etc.
FROM apbarratt/ubuntu-18-with-node-carbon

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

# And go
COPY startTilemill.sh /startTilemill.sh
RUN chmod 777 /startTilemill.sh
RUN /startTilemill.sh

# Expose ports for tilemill
EXPOSE 20009
EXPOSE 20008