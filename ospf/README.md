для разворачивания стенда запускаем vagrant up

после развертывания разворачивается ospf с симметричным роутингом
для ассиметричного добавляем false в defaults/main.yml

и запускаем плейбук:
ansible/assymetricRouting.yml

для применения изменений раскомменчиваем в Vagrantfile
#ansible.tags

и запускаем vagrant provision

