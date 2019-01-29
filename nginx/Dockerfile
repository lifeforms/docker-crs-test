FROM debian:testing
LABEL maintainer="walter@lifeforms.nl"

ARG REPO=SpiderLabs/owasp-modsecurity-crs
ARG COMMIT=v3.1/dev

RUN apt-get update && \
    apt-get -y install build-essential fakeroot devscripts curl dialog procps git && \
    apt-get install -y libexpat-dev libgd-dev libgeoip-dev libhiredis-dev libluajit-5.1-dev libmhash-dev libpam0g-dev libpcre3-dev libperl-dev libssl-dev libxslt1-dev quilt zlib1g-dev libmodsecurity-dev wget && \
    apt-get -y install python python-pip git ca-certificates

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /root/nginx && \
    cd /root/nginx && \
    wget http://ftp.debian.org/debian/pool/main/n/nginx/nginx_1.14.2.orig.tar.gz && \
    git clone https://salsa.debian.org/airween-guest/nginx.git/ && \
    cd nginx && \
    git checkout modsecurity && \
    debuild -us -uc && \
    cd .. && \
    dpkg -i libnginx-mod-http-modsecurity_1.14.2-3_amd64.deb nginx-light_1.14.2-3_amd64.deb nginx-common_1.14.2-3_all.deb libnginx-mod-http-echo_1.14.2-3_amd64.deb

RUN cd / && \
	git clone https://github.com/${REPO}.git crs && \
	cd crs && \
	git checkout -qf ${COMMIT} && \
	cp crs-setup.conf.example crs-setup.conf

RUN cd /crs/ && \
	pip install -r ./util/integration/requirements.txt && \
	pip install -r ./util/regression-tests/requirements.txt

COPY crs-serve.conf /etc/nginx/conf.d/crs-serve.conf
COPY crs-test.conf /etc/nginx/conf.d/crs-test.conf

COPY run-tests.sh /
COPY serve.sh /

EXPOSE 80

CMD ["/run-tests.sh"]
