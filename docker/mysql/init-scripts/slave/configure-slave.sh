#!/bin/bash
set -e

# Master가 완전히 시작될 때까지 대기
until mysqladmin ping -h"local-db-master" -u"repluser" -p"repluser" --silent; do
    echo "Waiting for master database connection..."
    sleep 5
done

# Master의 현재 로그 위치 가져오기
MASTER_STATUS_FILE="/tmp/master_status.txt"
mysql -h local-db-master -urepluser -prepluser -e "SHOW MASTER STATUS\G" > "$MASTER_STATUS_FILE"

MASTER_LOG_FILE=$(grep "File:" "$MASTER_STATUS_FILE" | awk '{print $2}')
MASTER_LOG_POS=$(grep "Position:" "$MASTER_STATUS_FILE" | awk '{print $2}')

echo "MASTER_LOG_FILE: $MASTER_LOG_FILE"
echo "MASTER_LOG_POS: $MASTER_LOG_POS"

# Slave 설정
mysql -uroot -proot -e "
CHANGE MASTER TO
    MASTER_HOST='local-db-master',
    MASTER_USER='repluser',
    MASTER_PASSWORD='repluser',
    MASTER_LOG_FILE='$MASTER_LOG_FILE',
    MASTER_LOG_POS=$MASTER_LOG_POS,
    GET_MASTER_PUBLIC_KEY = 1;
START SLAVE;
"

# Slave 상태 확인
mysql -uroot -proot -e "SHOW SLAVE STATUS\G"
