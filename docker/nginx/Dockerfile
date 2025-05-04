# Используем официальный образ nginx
FROM nginx:stable-alpine

# Создаем нового пользователя и группу
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Устанавливаем необходимые пакеты для Python, Flask и создания виртуального окружения
RUN apk add --no-cache python3 py3-pip gcc musl-dev libffi-dev

# Создаем виртуальное окружение для Python
RUN python3 -m venv /venv

# Активируем виртуальное окружение и устанавливаем Flask
RUN /venv/bin/pip install flask

# Устанавливаем fcgiwrap и другие утилиты
RUN apk add --no-cache procps spawn-fcgi fcgiwrap bash curl python3 py3-pip py3-flask

# Создаем директории для серверов, используя пользователя appuser
RUN mkdir -p /app /run && chown -R appuser:appgroup /app /run
RUN mkdir -p /var/cache/nginx/client_temp && chown -R appuser:appgroup /var/cache/nginx

# Копируем конфигурации Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY cont/ /usr/share/nginx/
COPY ssl/ /etc/ssl/private/

# Копируем Python-скрипты
COPY server_red.py /app/server_red.py
COPY server_blue.py /app/server_blue.py

# Копируем скрипт для запуска серверов
COPY start_servers.sh /start_servers.sh

# Даем права на выполнение скрипта
RUN chmod 755 /start_servers.sh
RUN chmod 755 /app/server_red.py
RUN chmod 755 /app/server_blue.py

# Открываем порты для Nginx и Python серверов
EXPOSE 443
EXPOSE 8080 
EXPOSE 8081 

# Меняем владельца файлов на appuser
RUN chown -R appuser:appgroup /app /usr/share/nginx /etc/ssl/private

# Указываем пользователя для запуска nginx
USER appuser

# Запускаем серверы и Nginx
CMD ["/bin/sh", "/start_servers.sh"]

