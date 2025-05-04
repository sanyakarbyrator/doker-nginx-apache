#!/bin/bash
#!/bin/bash
echo -e "Content-type: text/html\n"

# Получение загрузки CPU за несколько секунд
cpu_load=$(top -bn2 | grep "Cpu(s)" | tail -n 1 | awk '{print 100 - $8}')  # $8 — это idle

echo "<html><head><meta charset='UTF-8'><title>CPU Load</title></head><body>
<h1>CPU Load: $cpu_load%</h1>
</body></html>"

