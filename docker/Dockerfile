FROM python:alpine as base

# build dependencies
FROM base as builder

RUN mkdir /install
WORKDIR /install
COPY requirements.txt /requirements.txt
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

CMD ["uwsgi", "---chdir connaisseur", "--wsgi-file flask_server", "--callable APP", "--master", "---processes 2", "--threads 1", "--https :5000,/etc/certs/tls.crt,/etc/cert/tls.key"]
