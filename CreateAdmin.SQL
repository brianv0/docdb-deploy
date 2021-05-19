insert into SecurityGroup set Name='${ADMIN_NAME}',Description='DocDB Administrators',CanCreate=1,CanAdminister=1 ON DUPLICATE KEY UPDATE CanCreate=1,CanAdminister=1;
