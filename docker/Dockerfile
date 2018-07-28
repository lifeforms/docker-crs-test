FROM owasp/modsecurity:v2-ubuntu-apache
LABEL maintainer="walter@lifeforms.nl"

ARG REPO=SpiderLabs/owasp-modsecurity-crs
ARG COMMIT=v3.1/dev

RUN apt-get update && \
    apt-get -y install python python-pip git ca-certificates

RUN cd / && \
	git clone https://github.com/${REPO}.git crs && \
	cd crs && \
	git checkout -qf ${COMMIT} && \
	cp crs-setup.conf.example crs-setup.conf

RUN cd /crs/ && \
	pip install -r ./util/integration/requirements.txt && \
	pip install -r ./util/regression-tests/requirements.txt

COPY zzz.conf /etc/apache2/modsecurity.d/zzz.conf

COPY run-tests.sh /
COPY serve.sh /

EXPOSE 80

CMD ["/run-tests.sh"]
