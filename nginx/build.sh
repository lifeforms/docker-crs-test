#!/bin/sh
docker build -t nginx-crs-test . || exit 1
docker tag nginx-crs-test lifeforms/nginx-crs-test || exit 2
