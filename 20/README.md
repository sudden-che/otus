# устанавливаем freeipa и добавляем клиента
# поднимаем сервер

vagrant up ipaserver

# логинимся и устанавливаем
ipa-server-install

# после установки перезагружаем, когда перезагрузится выдаем тикет керберос
kinit admin

# смотрим 
klist

# поднимаем клиент, вводим его в домен
vagrant up ipaclient

