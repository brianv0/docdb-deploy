FROM centos:7

RUN yum update -y && \
   yum install -y perl && \
   yum install -y epel-release && \ 
   yum install -y httpd gettext httpd-tools sendmail sendmail-cf

RUN yum install -y perl-CGI perl-App-cpanminus \
    perl-DateTime perl-DateTime-Format-ICal perl-XML-Grove perl-XML-Parser perl-DBI perl-File-MimeInfo perl-XML-Simple perl-DBD-MySQL

ENV DOCDB_VERSION=8.8.10b1

RUN cpanm CGI::Untaint File::MimeInfo Mail::Send Mail::Mailer XML::Twig HTML::TreeBuilder Data::ICal Data::ICal::Entry::Event && rm -rf /root/.cpan

ENV HTML_DIR=/var/www/html
ENV CGI_DIR=/var/www/cgi-bin
ENV APP_NAME=DocDB

WORKDIR /var/www
RUN curl -LO https://github.com/ericvaandering/DocDB/archive/${DOCDB_VERSION}.tar.gz
RUN tar -xzf ${DOCDB_VERSION}.tar.gz && rm ${DOCDB_VERSION}.tar.gz && \
    mv DocDB-${DOCDB_VERSION}/DocDB/html html/DocDB && \
    mv DocDB-${DOCDB_VERSION}/DocDB/cgi cgi-bin/DocDB && \
    rm -rf DocDB-${DOCDB_VERSION}

# Note: We don't have user namespaces and we want to modify files here on start
RUN chmod ugo+rwx /run/httpd && \
    chmod ugo+w cgi-bin/DocDB && \
    chmod ugo+w /etc/httpd/conf && \
    chmod -R ugo+rwx /var/log/httpd

ADD run.sh /

# Overwrite non-substitutable template
ADD ProjectGlobals.pm.template ${CGI_DIR}/DocDB/ProjectGlobals.pm.template

# fix cgi paths in ScriptAlias config
RUN export cgi_path_escaped="\/${APP_NAME}"; \
    export cgi_app_escaped=$(echo "${CGI_DIR}/${APP_NAME}" | sed 's/\//\\\//g'); \
    sed -i.orig 's/ScriptAlias \/cgi-bin\/ "\/var\/www\/cgi-bin\/"/ScriptAlias '${cgi_path_escaped}'\/cgi\/ "'${cgi_app_escaped}'\/"/' /etc/httpd/conf/httpd.conf

# fix so we can bind port 80
RUN sed -i.orig2 's/Listen \(.*\)80/Listen \18080/' /etc/httpd/conf/httpd.conf

# Removing extra /Static path
RUN sed -i.orig 's/\/Static//' ${CGI_DIR}/${APP_NAME}/DocDBGlobals.pm


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

ENTRYPOINT /run.sh
