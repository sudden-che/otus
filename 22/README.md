## при запуске разворачивается 4 сервера
1. inetRouter - шлюз, доступ в интернет; 192.168.50.10
порт-кноккинг реализован через knockd

```
логи с клиента и сервера в файлах knockd-client.log  knockd-inetRouter.log
```

2. inet2Router - через порт 8080 переадресовывает запросы на centralServer порт 80; 192.168.50.11

3. centralRouter - клиент port knocking чтобы постучаться по заранее сконфигурированным портам запускаем скрипт /opt/knock.sh
```
bash ~/knock.sh 192.168.50.10
```

4. centralServer - nginx на 80 порту

* для проверки переадресации можно использовать
curl --head 192.168.50.11:8080

```
[root@inetRouter vagrant]# curl --head 192.168.50.11:8080
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Wed, 18 May 2022 13:52:34 GMT
Content-Type: text/html
Content-Length: 4833
Last-Modified: Fri, 16 May 2014 15:12:48 GMT
Connection: keep-alive
ETag: "53762af0-12e1"
Accept-Ranges: bytes

```
