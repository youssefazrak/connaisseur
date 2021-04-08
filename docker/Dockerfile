FROM python:alpine as base

# build dependencies
FROM base as builder

RUN mkdir /install
WORKDIR /install
COPY requirements.txt /requirements.txt
# need libc-dev gcc and linux headers for building uwsgi #TODODODODODODO
# need openssl-dev to build with https support
RUN apk add gcc libc-dev linux-headers openssl-dev # TODO check what needed
RUN pip install --no-cache-dir --prefix=/install -r /requirements.txt

# build connaisseur image
FROM base

WORKDIR /app

# Harden image
COPY docker/harden.sh /
RUN sh /harden.sh && rm /harden.sh

# Copy source code and install packages
COPY --from=builder /install /usr/local
COPY connaisseur /app/connaisseur


LABEL maintainer="Philipp Belitz <philipp.belitz@securesystems.de>"

CMD ["uwsgi", "--wsgi-file", "connaisseur/flask_server.py", "--callable", "APP", "--master", "--processes", "2", "--threads", "1", "--https", "0.0.0.0:5000,/etc/certs/tls.crt,/etc/certs/tls.key", "--log-4xx", "--log-5xx", "--disable-logging"]
