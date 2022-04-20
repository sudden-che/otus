# теоретическое задание с подсчетом подсетей
nets.xlsx

# карта сети
map.png

# файл для провижинга лабы 
provision.yml

# ansible inv
hosts

# шаблоны конфигов сетей серверов
templates









# результаты выполнения задания

# трассировки интернета и серверов между собой
# server 2 to inet
office2server (0.0.0.0)                                                                                                                                                   Wed Apr 20 14:30:28 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.1.1                                                                                                                                          0.0%     3    1.3   1.6   1.3   1.9   0.0
 2. 192.168.255.5                                                                                                                                        0.0%     3    3.0   2.9   2.8   3.0   0.0
 3. 192.168.255.1                                                                                                                                        0.0%     3    4.2   4.2   3.9   4.5   0.0
 4. ???
 5. ???
 6. ???
 7. ???
 8. msk-ix.cloudflare.com                                                                                                                                0.0%     2   12.6  10.7   8.7  12.6   2.6
 9. one.one.one.one                                                                                                                                      0.0%     2   64.1  68.1  64.1  72.0   5.6



# office router to inet
office2router (0.0.0.0)                                                                                                                                                   Wed Apr 20 14:27:36 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.255.5                                                                                                                                        0.0%     4    2.0   2.2   1.4   2.9   0.0
 2. 192.168.255.1                                                                                                                                        0.0%     4    3.3   3.0   2.7   3.3   0.0
 3. ???
 4. ???
 5. ???
 6. M9-2-FastE.MSK.macomnet.net                                                                                                                          0.0%     4    4.7   4.8   4.2   5.5   0.0
 7. msk-ix.cloudflare.com                                                                                                                                0.0%     3   11.1   9.0   7.1  11.1   1.9
 8. one.one.one.one      
 
# central router to inet 
centralRouter (0.0.0.0)                                                                                                                                                   Wed Apr 20 14:31:40 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.255.1                                                                                                                                        0.0%     2    1.7   1.7   1.6   1.7   0.0
 2. ???
 3. ???
 4. host-225.FORWARD.213.247.189.224.0xfffffff8.macomnet.net                                                                                             0.0%     1    3.8   3.8   3.8   3.8   0.0
 5. M9-2-FastE.MSK.macomnet.net                                                                                                                          0.0%     1    3.3   3.3   3.3   3.3   0.0
 6. msk-ix.cloudflare.com                                                                                                                                0.0%     1    5.5   5.5   5.5   5.5   0.0
 7. one.one.one.one                                                                                                                                      0.0%     1   43.9  43.9  43.9  43.9   0.0


# server1 to inet
office1Server (0.0.0.0)                                                                                                                                                   Wed Apr 20 15:16:50 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.2.129                                                                                                                                        0.0%    58    1.8   1.6   1.1   2.3   0.0
 2. 192.168.255.9                                                                                                                                        0.0%    58    2.8   3.0   2.4   6.3   0.5
 3. 192.168.255.1                                                                                                                                        0.0%    58    4.3   4.3   3.6   5.1   0.0
 4. ???
 5. ???
 6. ???
 7. ???
 8. msk-ix.cloudflare.com                                                                                                                                0.0%    57   10.4   9.6   7.2  23.2   2.5
 9. one.one.one.one                                                                                                                                      0.0%    57   74.2  64.3  38.9  88.8  11.5



# office router to inet
office1Router (0.0.0.0)                                                                                                                                                   Wed Apr 20 15:17:39 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.255.9                                                                                                                                        0.0%     6    1.7   1.7   1.4   2.0   0.0
 2. 192.168.255.1                                                                                                                                        0.0%     6    2.6   3.1   2.6   3.4   0.0
 3. ???
 4. ???
 5. ???
 6. M9-2-FastE.MSK.macomnet.net                                                                                                                          0.0%     6    4.7   4.9   4.5   5.2   0.0
 7. msk-ix.cloudflare.com                                                                                                                                0.0%     6   18.5   9.9   6.5  18.5   4.8
 8. one.one.one.one                                                                                                                                      0.0%     5   66.3  65.0  57.6  69.9   4.9




# central server to inet
centralServer (0.0.0.0)                                                                                                                                                   Wed Apr 20 15:48:27 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.0.1                                                                                                                                          0.0%     2    1.6   1.5   1.5   1.6   0.0
 2. 192.168.255.1                                                                                                                                        0.0%     2    2.9   2.9   2.9   2.9   0.0
 3. ???
 4. ???
 5. ???
 6. M9-2-FastE.MSK.macomnet.net                                                                                                                          0.0%     2    4.7   4.7   4.7   4.8   0.0
 7. msk-ix.cloudflare.com                                                                                                                                0.0%     2    9.9   8.5   7.0   9.9   2.0
 8. one.one.one.one                                                                                                                                      0.0%     1   86.8  86.8  86.8  86.8   0.0


# server2 to server1 and back
                                                                                     My traceroute  [v0.85]
office2server (0.0.0.0)                                                                                                                                                   Wed Apr 20 16:30:32 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.1.1                                                                                                                                          0.0%     8    1.7   1.7   1.5   2.2   0.0
 2. 192.168.255.5                                                                                                                                        0.0%     7    2.8   3.0   2.8   3.3   0.0
 3. 192.168.255.10                                                                                                                                       0.0%     7    5.4   4.6   3.9   5.4   0.0
 4. 192.168.2.130                                                                                                                                        0.0%     7    5.7   5.6   5.1   6.4   0.0


office1Server (0.0.0.0)                                                                                                                                                   Wed Apr 20 16:31:02 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.2.129                                                                                                                                        0.0%     4    1.6   1.8   1.5   2.4   0.0
 2. 192.168.255.9                                                                                                                                        0.0%     3    2.9   3.2   2.9   3.8   0.0
 3. 192.168.255.6                                                                                                                                        0.0%     3    4.2   4.3   3.9   4.7   0.0
 4. 192.168.1.2    
 
 
# central server to server1
                                                                                      My traceroute  [v0.85]
centralServer (0.0.0.0)                                                                                                                                                   Wed Apr 20 16:33:25 2022
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                                                          Packets               Pings
 Host                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.0.1                                                                                                                                          0.0%    20    1.5   1.7   1.5   2.8   0.2
 2. 192.168.255.10                                                                                                                                       0.0%    20    2.7   3.0   2.7   3.7   0.0
 3. 192.168.2.130                                                                                                                                        0.0%    20    4.1   4.3   3.7   7.0   0.6








 




 
 
 
 
 
 
 
 
 





