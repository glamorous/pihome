mysql -u root -p$MYSQL_ROOT_PASSWORD --execute \
"
CREATE OR REPLACE USER 'homeassistant'@'%' IDENTIFIED BY '$HA_DB_PASSWORD';
GRANT ALL PRIVILEGES ON homeassistant.* TO 'homeassistant'@'%';
"
