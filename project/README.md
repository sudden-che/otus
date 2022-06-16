
ansible-galaxy collection install community.zabbix

# todo create database
check realdb vs delegated_dbhost; change pwd to =! !

fatal: [monitoring -> 192.168.50.40]: FAILED! => {"changed": false, "msg": "(1045, u\"Access denied for user '********'@'%' (using password: YES)\")"}
real server or no

zabbix_server_real_dbhost: 
#192.168.50.40


Цель:
Создание рабочего проекта
веб проект с развертыванием нескольких виртуальных машин должен отвечать следующим требованиям:

включен https;
основная инфраструктура в DMZ зоне;
файрвалл на входе;
сбор метрик и настроенный алертинг;
везде включен selinux;
организован централизованный сбор логов.
организован backup базы