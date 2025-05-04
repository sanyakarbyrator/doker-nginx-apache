#!/bin/sh

. /venv/bin/activate

# Запускаем Python серверы
python3 /app/server_red.py &  
python3 /app/server_blue.py & 

spawn-fcgi -s /run/fcgiwrap.socket -U appuser -G appgroup -- /usr/bin/fcgiwrap
#spawn-fcgi -s /run/fcgiwrap.socket -U appuser -G appgroup /usr/sbin/fcgiwrap

# Запускаем Nginx
nginx -g "daemon off;"

