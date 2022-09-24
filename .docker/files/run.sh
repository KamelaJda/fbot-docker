#!/bin/bash

echo "___________              __  .__ __   ____________________________"
echo "\_   _____/___________ _/  |_|__|  | _\______   \   _  \__    ___/"
echo " |    __) \_  __ \__  \\   __\  |  |/ /|    |  _/  /_\  \|    |   "
echo " |     \   |  | \// __ \|  | |  |    < |    |   \  \_/   \    |   "
echo " \___  /   |__|  (____  /__| |__|__|_ \|______  /\_____  /____|   "
echo "     \/               \/             \/       \/       \/      "
echo " "

# Copy file config
if [ -f "/files/config.json/config.json" ]
then
  echo "Plik konfiguracyjny zaladowany!"
  cp "/files/config.json/config.json" .
else
  echo "Nie znalezniono pliku konfiguracyjnego!"
  exit 0
fi

# Copy core
if [ "$(ls /files/jars/core/ -b | wc -l)" -ge 2 ];
then
  echo "W folderze ,,core'' znajduja sie conajmniej dwa pliki!"
  exit 0
else
  for file in /files/jars/core/*;
  do
    cp "$file" .
    CORE_VERSION=$(basename "${file}" .jar | cut -d "-" -f2)
  done

  echo " "
  echo "Core w wersji ${CORE_VERSION} zaladowany!"
  echo " "
fi

# Copy plugins
SUCCESS=0
FAILS=0

echo "Zaczynam ladowac pluginy..."

for file in /files/jars/plugins/*;
do
  PLUGIN_VERSION=$(unzip -qc "${file}" plugin.json | jq -r '.coreVersion')
  PLUGIN_NAME=$(unzip -qc "${file}" plugin.json | jq -r '.name')

  if [ X"$PLUGIN_VERSION" = X"$CORE_VERSION" ];
  then
    echo "  Plugin ,,${PLUGIN_NAME}'' zostal pomyslnie zaladowany!"
    cp "$file" plugins/
    SUCCESS=$((SUCCESS + 1))
  else
    echo "  Plugin ,,${PLUGIN_NAME}'' posiada nieprawidlowa wersje core'a! (${PLUGIN_VERSION})"
    FAILS=$((FAILS + 1))
  fi
done

# Start service
exec java -Xms${MIN_MEMORY} -Xmx${MAX_MEMORY} -jar core-*.jar ${BOT_TOKEN}