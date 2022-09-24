#!/bin/bash

FILE_NAME=lavalink.jar
URL=https://github.com/freyacodes/Lavalink/releases/download/${LAVALINK_VERSION}/Lavalink.jar

if [ ! -f "/files/application.yml/application.yml" ];
then
  echo "Nie odnaleziono pliku application.yml!"
  exit 0
else
  cp "/files/application.yml/application.yml" .
fi

if [ ! -f ${FILE_NAME} ];
then
  echo "Rozpoczynam pobieranie lavalinka..."
  wget ${URL} -qO ${FILE_NAME}
fi

exec java -Xms${MIN_MEMORY} -Xmx${MAX_MEMORY} -jar ${FILE_NAME}