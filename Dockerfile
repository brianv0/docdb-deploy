FROM centos:7

RUN yum update -y && \
   yum install -y perl && \
   yum install -y epel-release && \
   yum install -y uwsgi uwsgi-plugin-common gettext

RUN yum install -y perl-CGI perl-App-cpanminus \
    perl-DateTime perl-DateTime-Format-ICal perl-XML-Grove perl-XML-Parser perl-DBI perl-File-MimeInfo perl-XML-Simple perl-DBD-MySQL

ENV DOCDB_VERSION=8.8.10b1

RUN cpanm CGI::Untaint File::MimeInfo Mail::Send Mail::Mailer XML::Twig HTML::TreeBuilder Data::ICal Data::ICal::Entry::Event && rm -rf /root/.cpan

WORKDIR /app
RUN chown uwsgi:uwsgi /app
USER uwsgi
RUN curl -LO https://github.com/ericvaandering/DocDB/archive/${DOCDB_VERSION}.tar.gz
RUN tar -xzf ${DOCDB_VERSION}.tar.gz && rm ${DOCDB_VERSION}.tar.gz && \
    mv DocDB-${DOCDB_VERSION}/* /app/. && ls -alR DocDB-${DOCDB_VERSION} && rm -rf DocDB-${DOCDB_VERSION}

ADD uwsgi.ini run.sh /app/
# Overwrite non-substitutable template
ADD ProjectGlobals.pm.template /app/DocDB/cgi/ProjectGlobals.pm.template

ENV ADMIN_EMAIL=root@localhost
ENV ADMIN_NAME=admin
ENV DB_HOST="db"
ENV DB_NAME="docdb"
ENV DB_ROUSER="docdb-rouser"
ENV DB_ROPASSWORD=
ENV DB_RWPASSWORD=
ENV DB_RWUSER="docdb-rwuser"
ENV FIRST_YEAR=2000
ENV PROJECT_NAME=Project
ENV PROJECT_SHORTNAME=Proj
ENV SERVER_URL=http://localhost:8080
ENV SMTP_HOSTNAME=localhost

ENTRYPOINT /app/run.sh
