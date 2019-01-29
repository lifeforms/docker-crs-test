#!/bin/sh
./build.sh || exit 1
docker push lifeforms/nginx-crs-test