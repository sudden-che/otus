при запуске стенда (vagrant up) происходит:

    - разворачивание 2х серверов
        - mysql1 - мастер репликации
        - mysqlslave - slave

    - на них ставятся бд перкона из репозитория
    - копируются конфиги 
    - восстанавливается дамп бд
    - создется пользователь для репликации
    - делается дамп бд без лишний таблиц
    - через ансибл загружается на слейва, где включается репликация с мастером через gtid

процесс работы можно видеть в приложенном скрине 
![mysql_repl.png](https://github.com/sudden-che/otus/tree/main/mysql/mysql_repl.png)