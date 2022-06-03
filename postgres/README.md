для работы развертываения через ансибл требуется предварительная установка модуля postgres
\\ ansible-galaxy collection install community.postgresql

при старте стенда разворачивается 4 хоста
psql1:
    бд с таблицами 1 (публикация),2 (подписка на psql2)

psql2:
    бд с таблицами 2 (публикация),1 (подписка на psql1)

psql3: подписки на psql1(таблица1) , psql2 (таблица2)

psql4: <- репликация  <- psql3


для корректного порядка развертывания и настройки подписок, после vagrant up нужно дополнтилеьно запустить плейбук subscribe.yml

результаты работы:

![mysql_repl.png](https://github.com/sudden-che/otus/tree/main/mysql/mysql_repl.png)

