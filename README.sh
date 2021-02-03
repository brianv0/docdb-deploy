
1. Initialize
export DB_BIND_DIR=`pwd`/vol
export DB_NAME=docdb
export DB_USER=docuser
source init.sh

2. Run
docker-compose up

DocDB Storage Path:
/var/lib/docdb/

Try a url:
http://localhost:8081/DocDB/cgi-bin/DocumentDatabase

DocDB Template Vars:
ADMIN_EMAIL
ADMIN_NAME
DB_HOST
DB_NAME
DB_ROPASSWORD
DB_ROUSER
DB_RWPASSWORD
DB_RWUSER
FIRST_YEAR
PROJECT_NAME
PROJECT_SHORTNAME
SERVER_URL
SMTP_HOSTNAME
