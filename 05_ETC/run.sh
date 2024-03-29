#!/bin/bash

function usage {
  cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h          Display help
  -b          Build server container
  -d          Delete container
  -s          Start Container
EOM

  exit 2
}

function server_build {

  # readonly server_path="//c//workspace//HaveTodo//HaveTodoServer"
  readonly home_path="//c//Users/$(whoami)"

  # docker run -it --rm --name my-maven-project \
  #   -v "$server_path:/usr/src/mymaven" \
  #   -v "$home_path/.m2":/root/.m2 \
  #   -v "$server_path/target:/usr/src/mymaven/target" \
  #   -w //usr/src/mymaven maven:3.8.5-amazoncorretto-17 mvn clean package

  docker build -t havetodo/server:latest "../../HaveTodoServer"
  echo y | docker image prune # noneなイメージ削除
}

while getopts "sbdrh" optKey; do
  case "$optKey" in
    b)
      docker build -t havetodo/client:latest ../../HaveTodoClient
      docker build -t havetodo/e2e:latest ./e2e
      # cd ../../HaveTodoServer && ./mvnw compile jib:dockerBuild && cd "$PWD" #Jibを使ったイメージビルド
      server_build
      echo "Builded containers."
      exit 0
      ;;
    d)
      docker-compose -p havetodo down --volumes --remove-orphans # コンテナ等削除
      docker-compose -p havetodo ps # プロセス確認
      echo ""
      echo "Deleted containers."
      exit 0
      ;;
    r)
      docker-compose -p havetodo restart
      docker-compose -p havetodo ps # プロセス確認
      echo ""
      echo "Restarted containers."
      exit 0
      ;;
    s)
      docker-compose -p havetodo up -d # 各コンテナ実行
      sleep 3 # 開始ログを出力するために少しスリープ
      docker-compose -p havetodo ps # プロセス確認
      echo ""
      echo "Start containers."
      exit 0
      ;;
    '-h'|'--help'|* )
      usage
      ;;
  esac
done

echo "You must specify option \"-s\" \"-b\" \"-d\" \"-h\""
usage
