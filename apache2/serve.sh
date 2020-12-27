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
ln -sf /dev/stdout /var/log/apache2/access.log
ln -sf /dev/stderr /var/log/apache2/error.log

# Don't use our testing configuration for CRS.
# Overwrite it with a minimal default.
cat << EOF > /etc/apache2/conf-enabled/zzz.conf
# This file has been rewritten by serve.sh
SecAction "id:900005,\
  phase:1,\
  nolog,\
  pass,\
  ctl:ruleEngine=On"

Include /crs/*.conf
Include /crs/rules/*.conf
EOF

# Start Apache in the foreground.
apachectl -D FOREGROUND || exit 20
