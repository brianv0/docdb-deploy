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

WORKDIR /var/www
RUN curl -LO https://github.com/ericvaandering/DocDB/archive/${DOCDB_VERSION}.tar.gz
RUN tar -xzf ${DOCDB_VERSION}.tar.gz && rm ${DOCDB_VERSION}.tar.gz && \
    mv DocDB-${DOCDB_VERSION}/DocDB/html html/DocDB && \
    mv DocDB-${DOCDB_VERSION}/DocDB/cgi cgi-bin/DocDB && \
    rm -rf DocDB-${DOCDB_VERSION}

ADD run.sh /

# Overwrite non-substitutable template
ADD ProjectGlobals.pm.template ${CGI_DIR}/DocDB/ProjectGlobals.pm.template

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
