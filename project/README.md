# Otus Administrator Linux Professional
## Развертывание инфрастурктуры для веб приложения с использованием методов IaC

## Цель:
Создание рабочего проекта
веб проект с развертыванием нескольких виртуальных машин должен отвечать следующим требованиям:

* включен https;
* основная инфраструктура в DMZ зоне;
* файрвалл на входе;
* сбор метрик и настроенный алертинг;
* везде включен selinux;
* организован централизованный сбор логов.
* организован backup базы

## Сетевая схема инфраструктуры проекта

![net_map.svg](https://raw.githubusercontent.com/sudden-che/otus/5ce1916caa921833d49ce98f1340620c6f742fe7/project/net_map.svg)
## Cписок серверов в проекте:

* inetRouter (10.10.20.254)    - пограничный шлюз, фаервол, nginx proxy сервер, единая точка входа
* wordpress  (10.10.20.10)     - сервер включающий в себя хост машину, для приложений. На нем из Dockerfile разворачивается wordpress, а так же nginx сервер, на котором он работает
* mysql      (10.10.20.20)     - основной сервер баз данных сайта wordpress, мастер репликации
* mysqlslave (10.10.20.30)     - slave-сервер репликации бд
* backup     (10.10.20.40)     - сервер-хранилище резервного копирования
* logserver  (10.10.20.45)     - центральный сервер сбора логов со всех серверов инфраструктуры
* monitoring (10.10.20.50)     - центральный сервер мониторинга инфрастукруры, работает на zabbix 6.0

В качестве системы для всех виртуальных машин используется Vagrant "box centos/7", "bento/centos-stream-8"

## Развертывание инфраструктуры

После создания виртуальных машин по лекалам Vagrantfile, запускается общий плейбук для развертывания и настройки сервисов, состоящий и следующих ролей в следующем порядке:

1. Базовая установка репозиториев и ПО
2. Настройка шлюза 
3. Настройка серверов БД
4. Настройка сайта на вордпресс
5. Настройка сервера мониторинга
6. Настройка сервера логов
7. Настройка сервера бекапов

```
- name: project
  hosts: all
  gather_facts: true
  become: true
  roles:
    - setup

- name: project provision custom roles
  hosts: all
  gather_facts: true
  become: true

  tasks:
  - name: gateway provision
    include_role: name=gateway
    when: ansible_hostname == 'gateway'
    tags: gw

{...}

  - name: backup config provision
    include_role: name=backup
    when: config_backup == true
    tags: backup

```

### Для задания необходимых параметров используется файл group_vars\all.yml

### Для настройки сервера мониторинга из коллекции community.zabbix используются файлы с переменными для необходимой роли
пр. community.zabbix\roles\zabbix_server\defaults\main.yml

## Описание серверов и их функционала
### inetRouter
Шлюз по умолчанию для всех серверов, фаервол на основе firewalld, nginx сервер, переадресовывающий запросы на сервер вордпрес, по протоколу HTTPS, с самоподписанным сертификатом для обеспечения шифрования траффика
---
роль для настройки: gateway

### mysql и mysqlslave
Основной сервер Бд для вордпресс, мастер репликации
mysqlslave слейв сервер репликации, так же выполняет полное резервное копирование в папку /var/bak, из которой потом с помощью borgbackup архивируется в репозиторий
для корректного развертывания репликации, в inventory задаются переменные 
```
# для мастера
server_id=1 
# для слева
server_id=2
```
Основные переменные из group_vars.all связанные с ролью
```
# mysql 
mysql_pass: Ctrhtnysqgfhjkm1$ #Секретныйпароль1$
mysql_user: root
mysql_port: 3306
mysql_db_name: wordpress
server_hostname: wordpress
core_update_level: true

# Если стоит true, будет настроена репликация сервера бд  на слев true / false 
replication_enabled: true
# true будет восстановлена база данных из файла dump_m.sql / false будет создана новая бд /dump будет создан дамп базы данных, для разворачивании на slave-сервере
restore_db: dump
# адрес слейв сервера, для указания при создании пользователя репликации
slave_ip: '%'

# пароль пользователя репликации
repl_user_pwd: "!OtusLinux2018repl"
# if master fale change wp_db to slave ansible-playbook wordpress.yml --extra-vars=wp_db_host=10.10.20.30 --tags=docker

# папка для локального бекапа бд mysql
mysql_local_bak: /var/bak

```
---
роль для настройки: mysql


#### Бекап и востановление с помощью xtrabackup
Процесс восстановления резервной копии включает в себя подготовку папки с копией и непосредственно восстановление в исходную директорию
```
xtrabackup --prepare --target-dir=/путь/к/папке/c/копией
# пр.
xtrabackup --prepare --target-dir=/var/bak
xtrabackup --copy-back --target-dir=/путь/к/папке/c/копией --data-dir=/папка/с/базой

# для успешного восстанолвения папка должна быть пустой
xtrabackup --prepare --target-dir=/var/bak --data-dir=/var/lib/mysql
```

### wordpress
В качестве  веб приложения в проекте выступает сайт на вордпресс, который разворачивается в контейнере Docker

```
version: '3.3'
services:
  wordpress:
    image: wordpress:6.0.0-fpm-alpine
    container_name: wordpress
    restart: unless-stopped
    environment:
      WORDPRESS_DB_NAME: "${DB_NAME}"
      WORDPRESS_DB_USER: "${DB_USER_NAME}"
      WORDPRESS_DB_PASSWORD: "${DB_ROOT_PASSWORD}"
      WORDPRESS_DB_HOST: "${DB_HOST}"
    volumes:
      - /home/vagrant/wordpress:/var/www/html:z      
    networks:
      - app-network

  nginx:
    image: nginx
    container_name: nginx
    restart: unless-stopped
    ports:
      - 80:80
      - 443:443
    volumes:
      - /home/vagrant/wordpress:/var/www/html:z
      - /home/vagrant/nginx-conf/nginx.conf:/etc/nginx/nginx.conf:z
      - /home/vagrant/nginx-conf/ssl:/etc/nginx/ssl:z
    networks:
      - app-network
    depends_on:
      - wordpress

networks:
  app-network:
    driver: bridge
```
Некоторые переменные для деплоя копируются с помощью ансибл на конечную машину, где используюстя в процессе сборки 
пример файла .env: 
```
# переменны для сборки вордпресс
DB_NAME=wordpress
DB_USER_NAME=wordpress
DB_HOST={{ wp_db_host }}
DB_ROOT_PASSWORD=!OtusLinux2018
```
После разворачивания контейнера и его запуска, попасть на сайт можно либо по адресу хоста, на котором работает докер, изнутри ифнраструктуры либо через inetRouter, как единую точку входа
при обращении по http, запрос будет автоматически переадресован на https конечного сервера

### Резервное копирование
Помимо репликации баз данных так же настроено резервное копирование некоторых директорий на серверах с помощью borgbackup
по умолчанию это папка /etc, для серверов mysql так же папка /var/bak, в которую ежедневно падает полный бекап бд с помощью xtrabackup

дополнительные папки задаются в inventory в паременной bak в кавычках и разделяются пробелом
пр.
``` 
bak_dir='/etc /var/log'
```

### Сервер мониторинга 
работает на zabbix 6.0, устанавливается согласно инструкции в коллекции community.zabbix (https://github.com/ansible-collections/community.zabbix)
Включает в себя роли zabbix-server, zabbix-web, zabbix-agent (для остальных хостов)

Для получения доступа к нему нужно заходить на сайт zabbix.example.com из локальной сети инфраструктуры, имя предварительно настраивается на всех машинах в /etc/hosts с помощью ansible
Так же при желании на бастионе в конфиге nginx добавляется location с описанием редиректа на фактическимй сервер, для простоты доступа

```
# zabbix
   server {
        listen       80;
        listen       [::]:80;
        server_name  zabbix.example.com;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;


        location / {
        proxy_pass http://10.10.20.50;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
        }

```

Дополнительно на нем настроен алертинг для отправки сообщений об ошибках администраторам, при условии того что их почта сконфигурирована в веб интерфейсе
В данном примере использована реальная почта another-che@yandex.ru
---
роль для установки: collect-logs
Так же стоит заметить, что перед развертыванием непосредственно всех служб сервера, веб, или агентов должнен быть предварительно установлен сервер бд mysql/pgsql подходящей версии 

При развертывании агентов, так же происходит их автоматическая регистрация на хосте. следует обратить внимание на следующие переменные окружения в файлах:
main.yml для сервера:
```
# в конфигах происходит поиск с помощью регулярного выражения, который некорректно отрабатывает ансибл, поэтому при возниконовении ошибок переменную репозитория приводим к следующему виду

zabbix_repo_yum:
#   - name: zabbix
#     description: Zabbix Official Repository - $basearch
#     baseurl: "{{ zabbix_repo_yum_schema }}://repo.zabbix.com/zabbix/{{ zabbix_version | regex_search('^[0-9]+.[0-9]+') }}/rhel/{{ ansible_distribution_major_version }}/$basearch/"
#     gpgcheck: "{{ zabbix_repo_yum_gpgcheck }}"
#     mode: '0644'
#     gpgkey: file:///etc/pki/rp      zabbix_repo_yum:
  - name: zabbix
    description: Zabbix Official Repository - $basearch
    baseurl: "{{ zabbix_repo_yum_schema }}://repo.zabbix.com/zabbix/{{ zabbix_version }}/rhel/{{ ansible_distribution_major_version }}/$basearch/"
    gpgcheck: "{{ zabbix_repo_yum_gpgcheck }}"
    mode: '0644'
    gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
    state: present
  - name: zabbix-non-supported
    description: Zabbix Official Repository non-supported - $basearch
    baseurl: "{{ zabbix_repo_yum_schema }}://repo.zabbix.com/non-supported/rhel/{{ ansible_distribution_major_version }}/$basearch/"
    mode: '0644'
    gpgcheck: "{{ zabbix_repo_yum_gpgcheck }}"
    gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
    state: present

# при раздельной установки бд для заббикса - адрес ноды с базой данных
zabbix_server_real_dbhost: #192.168.50.40
# для локальной установки
zabbix_server_dbhost: localhost #10.10.20.30
# имя локальной бд
zabbix_server_dbname: zabbix-server
# реквизиты для доступа
zabbix_server_dbuser: zabuser
zabbix_server_dbpassword: zabbix-server
# for root access
# реквизиты для базовой конфигурации и создания бд для заббикса
zabbix_server_mysql_login_user: root
zabbix_server_mysql_login_password: # zabbix-server
zabbix_server_mysql_login_port: 3306
```

### Сервер логов 
работает на основе rsyslog, все логи со всех машин падают на него




### Дополнительный плейбуки для развертывания и конфигурации стенда
* network.yml - отключает стандартный nat коннекшен созданный вагрантом, перенаправляя доступ в интернет через inetRouter