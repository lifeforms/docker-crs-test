#!/bin/sh
docker build -t crs-test docker || exit 1
docker tag crs-test lifeforms/crs-test || exit 2