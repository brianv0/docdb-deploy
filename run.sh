#!/bin/bash
cgi_path=/DocDB
cgi_dir=/var/www/cgi-bin${cgi_path}
if [[ ! -f ${cgi_dir}/ProjectGlobals.pm ]]; then
  echo "Generating ProjectGlobals.pm from environment variables"
  cat  ${cgi_dir}/ProjectGlobals.pm.template | envsubst "$(perl -e 'print "\$$_" for grep /^[_a-zA-Z]\w*$/, keys %ENV')" > ${cgi_dir}/ProjectGlobals.pm
fi

files=('ProjectHelp.xml' 'ProjectMessages.pm' 'ProjectRoutines.pm')

for f in ${files[@]}; do
  if [[ ! -f ${cgi_dir}/${f} ]]; then
    echo "Using default ${f}.template for ${f}"
    cp ${cgi_dir}/${f}.template ${cgi_dir}/${f}
  fi
done

if [[ -n ${DOCDB_ADMIN_USER} ]]; then
  echo "Clobbering ${cgi_dir}/.htpasswd with new admin user: ${DOCDB_ADMIN_USER}"
  htpasswd -b -c "${cgi_dir}/.htpasswd" "${DOCDB_ADMIN_USER}" "${DOCDB_ADMIN_PASSWORD}"
fi

if [[ -n ${DOCDB_USER} ]]; then
  echo "Adding ${DOCDB_USER} to ${cgi_dir}/.htpasswd"
  htpasswd -b "${cgi_dir}/.htpasswd" "${DOCDB_USER}" "${DOCDB_PASSWORD}"
fi

# fix cgi paths in ScriptAlias config
echo "Rewriting ScriptAlias rule in /etc/httpd/conf/httpd.conf"
cgi_path_escaped=$(echo ${cgi_path} | sed 's/\//\\\//g')
cgi_dir_escaped=$(echo ${cgi_dir}   | sed 's/\//\\\//g')
sed -i.orig 's/ScriptAlias \/cgi-bin\/ "\/var\/www\/cgi-bin\/"/ScriptAlias '${cgi_path_escaped}'\/cgi\/ "'${cgi_dir_escaped}'\/"/' /etc/httpd/conf/httpd.conf

#uwsgi --ini /var/www/uwsgi.ini
#sendmail -bd  FIXME: later
httpd -D FOREGROUND
