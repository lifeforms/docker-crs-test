# ./build.sh
# docker run lifeforms/crs-test

FROM owasp/modsecurity:2.9-apache-ubuntu
LABEL maintainer="walter@lifeforms.nl"

ARG REPO=coreruleset/coreruleset
ARG COMMIT=v3.4/dev

RUN echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

RUN apt-get -y update && \
	apt-get -y install python python-pip git ca-certificates

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd / && \
	git clone https://github.com/${REPO}.git crs && \
	cd crs && \
	git checkout -qf ${COMMIT} && \
	cp crs-setup.conf.example crs-setup.conf

RUN cd /crs/ && \
	pip install -r ./tests/regression/requirements.txt

COPY zzz.conf /etc/apache2/conf-enabled/zzz.conf

COPY run-tests.sh /
COPY serve.sh /

EXPOSE 80

CMD ["/run-tests.sh"]
