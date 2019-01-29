#!/bin/sh

[ `whoami` != "root" ] && {
	echo "This command should only be run from the Docker container."
	exit 1
}

# The CRS lives in directory /crs.
# I bundle the development version of the CRS, but usually, the user
# will mount their own CRS development directory into /crs instead.
cd /crs || exit 10

[ ! -f crs-setup.conf.example ] && {
	echo "Cannot find a CRS directory."
	exit 11
}

[ ! -f crs-setup.conf ] && {
	echo "Creating crs-setup.conf from example..."
	cp crs-setup.conf.example crs-setup.conf || exit 12
}

# Get logs into Docker.
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

# Don't use our testing configuration for CRS.
rm /etc/nginx/conf.d/crs-test.conf

# Start Nginx in the foreground.
nginx -g 'daemon off;' || exit 20
