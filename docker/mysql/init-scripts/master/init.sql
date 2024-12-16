CREATE USER 'repluser'@'%' IDENTIFIED WITH mysql_native_password BY 'repluser';
GRANT REPLICATION SLAVE ON *.* TO 'repluser'@'%';
# Slave에서 `show master status;` 명령어를 실행하기 위한 권한 추가
GRANT REPLICATION CLIENT ON *.* TO 'repluser'@'%';
FLUSH PRIVILEGES;
