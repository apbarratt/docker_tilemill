# Run base image script
/apbarratt/ubuntu-18-with-node-carbon-postgis.sh

# And go
systemctl start tilemill
systemctl enable tilemill