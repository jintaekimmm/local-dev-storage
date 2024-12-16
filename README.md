# Local Development Storage

MySQL Replication을 사용하는 로컬 개발 환경 구성

## Network 설정

다른 레포지토리의 컨테이너들과 통신하기 위해 먼저 Docker network를 생성해야 한다
```shell
$ docker network create --driver=bridge --attachable local-storage-net
```


## Installation
### Database 설정
- Default database: `test`
- Database 이름 변경이 필요한 경우
  1. docker-compose.yaml의 MYSQL_DATABASE 값 수정
  2. docker/mysql/init-scripts/slave/init.sql의 database 생성 구문 수정

### 실행 방법
```shell
$ docker compose -p local-dev-storage -f docker/docker-compose.yaml up -d --build
```

## 다른 프로젝트에서 연결하기

다른 프로젝트 레포지토리에서 docker compose를 실행해서 replication과 연결하기 위해선 docker network를 통해 연결해야한다

### 1. Docker Network 연결
docker-compose.yml에 network 설정을 추가합니다:

```docker
services:
  test-service:
    # ... 다른 설정 들
    networks:
      local-storage-net: {}

networks:
  local-storage-net:
    external: true
```

### 2. 환경 변수 설정
Database 연결을 위한 환경변수(env) 설정 예시:
```shell
DB_RW_HOST=local-db-master # Docker Compose 서비스명
DB_RW_PORT=3306
DB_RW_NAME=test
DB_RW_USER=root
DB_RW_PASSWORD=root

DB_RO_HOST=local-db-slave # Docker compose 서비스명
DB_RO_PORT=3306
DB_RO_NAME=test
DB_RO_USER=root
DB_RO_PASSWORD=root
```
