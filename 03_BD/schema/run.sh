#!/bin/bash

docker-compose up -d
sleep 5
docker-compose logs -t --tail="all"

readonly out_put_dir="//c//workspace//HaveTodo//HaveTodoDoc//03_BD//schema//output"
docker run --name schemaspy -v "$out_put_dir:/output" --net="host" schemaspy/schemaspy:latest -t pgsql \
-host localhost:4325 -db postgres -u postgres -p postgres

schemaspy_ctr_id=$(docker ps -a | grep schemaspy | awk '{print $1}')
docker rm -v -f "$schemaspy_ctr_id"

docker-compose down -v

cat ./sql/init.sql > ../../../HaveTodoServer/src/main/resources/db/migration/local/V1_0__create_table.sql
