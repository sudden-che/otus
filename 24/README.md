vagrant up для запуска и развертывания стенда для тестирования split dns

клиенты client1, 2

зоны: 
    dns.lab 
        имена: 
            web1 - смотрит на клиент1 
            web2 смотрит на клиент2 
    newdns.lab
        www - смотрит на обоих клиентов

split-dns:
    клиент1 - видит обе зоны, но в зоне dns.lab только web1 
    клиент2 видит только dns.lab