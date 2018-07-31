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

# Start Apache in the container.
# It will be cleaned up automatically when this script ends.
apachectl start || exit 20

py.test --tb=no -qs util/integration/format_tests.py || exit 10

# If an argument is passed, e.g. 920470, only run tests for that rule.
[ ! -z "$1" ] && {
	echo "Running tests for rule $1..."
	cd /crs
	test=`echo util/regression-tests/tests/*/$1.yaml`
	py.test --tb=no -vs util/regression-tests/CRS_Tests.py --rule="$test"
	exit
}

# Run all the tests (copied from Travis)

py.test -vs util/regression-tests/CRS_Tests.py --rule=util/regression-tests/tests/test.yaml || exit 11

# TODO: not all ruledirs are working, so list the stable ones here for now,
# and change to --ruledir_recurse=util/regression-tests/tests/ later.
for ruledir in \
	REQUEST-911-METHOD-ENFORCEMENT \
	REQUEST-913-SCANNER-DETECTION \
	REQUEST-921-PROTOCOL-ATTACK \
	REQUEST-930-APPLICATION-ATTACK-LFI \
	REQUEST-933-APPLICATION-ATTACK-PHP \
	REQUEST-941-APPLICATION-ATTACK-XSS \
	REQUEST-942-APPLICATION-ATTACK-SQLI \
	REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION
do
	py.test --tb=no -vs util/regression-tests/CRS_Tests.py --ruledir=util/regression-tests/tests/$ruledir
done
