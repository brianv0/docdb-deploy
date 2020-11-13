FROM alpine:latest

RUN apk add --update git perl curl uwsgi-cgi uwsgi-http

# Perl-specific things
# make, wget needed for cpanm

RUN apk add perl-cgi perl-xml-simple perl-app-cpanminus wget make
RUN cpanm CGI::Untaint

ENV DOCDB_VERSION=8.8.10b1

WORKDIR app
RUN curl -LO https://github.com/ericvaandering/DocDB/archive/${DOCDB_VERSION}.tar.gz
RUN tar -xzf ${DOCDB_VERSION}.tar.gz && rm ${DOCDB_VERSION}.tar.gz && \
    mv DocDB-${DOCDB_VERSION}/* /app/. && ls -alR DocDB-${DOCDB_VERSION} && rm -rf DocDB-${DOCDB_VERSION}
ADD uwsgi.ini /app
