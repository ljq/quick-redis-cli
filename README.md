### quick-redis-cli ###

[简体中文](README.zh-CN.md)  

 Universal redis-cli terminal operation and management shortcut script Version 1.1.0<br>
 (Script Last updated: 2016-10-21) <br>
 File Name: quick-redis-cli.sh <br>
 Copyright: 2016 Jack Liu (Liu Jianqiu Qiu)<br>
 License: MIT<br>
 Version: Version 1.1.0<br>
 
 Author: Jack Liu (Liu Jianqiu 秋)<br>
 Email: ceophp@163.com<br>
 QQ: 1099729311 404691073(work used)
 Created Init By Date: 2016-03-18<br>

[write reason]<br>
In practice, redis-cli is used to manage redis instances almost every day. Some repetitive operations are performed using shell script processes. Before that, a redis-cli quick connect script was written, which saves a lot of unnecessary time. The late idle time expands some of the functions. The script is very simple. There will be time to add more useful functions and batch redis instance functions for multi-instance management. A small number of servers are temporarily implemented with a shell to meet general operating requirements.
Subsequent extraction time is compiled into binary execution using Golang, and the execution efficiency is high.

Script 1.1.0 to achieve basic functions, follow-up time update will focus on the specific scene business batch


Redis-cli operations often have to repeatedly hit the command, in many business scenarios, the general redis GUI graphical interface management tools can not handle a few pain points: <br>
1. Regardless of the local or remote IP management, the password must be input repeatedly for password-containing operations. In addition, the high-intensity password is complex to set up safely, manual input is inefficient, and paste operations must be repeated.
2. In the production isolation environment on the line, the visualization GUI management software also has to be inconvenient and insecure through proxy management. Many operation and maintenance scenarios are not applicable and occupy the link resources.
3. In the CLI mode, the internal isolated redis instance server is frequently managed by the bastion machine (board springboard). The IP and password verification input repeats many operations and is error-prone. (The subsequent script update implements management of n instances and batch management.)
...

[main use]<br>
 Fast use of redis-cli terminal connection and switching in different operation and maintenance scenarios

[Disclaimer]<br>
 If you are unfamiliar with the script, do not operate directly on the production server. After the test environment is confirmed to be correct, use it again! <br>
The script is not confused with the code. It can be freely expanded according to its own business scenario. <br>

【Main Function Points】<br>


【Directory Structure】
<b>etc</b> configuration directory:<br>
<b>etc/README</b> Help Documentation<br>
<b>etc/server_list.conf</b> Management Instance Configuration <br>


[version 1.1.0 script help description (Best Update Date: 2016-10-21)]<br>
 Document Latest Update Date: 2016-11-01<br />

[script parameters]<br />
-v : View the current version of the script. <br />
-help : Check the help documentation. <br />
-list : Views the list of manageable instances and operates on the specified redis instance according to the number. <br>
-c [Number] : An instance of a quick selection operation based on the number. <br />

        
[main use]<br>
        Easy to use redis-cli terminal to manage redis instances in different operation and maintenance scenarios. <br>

 [Disclaimer]<br>
        If you are unfamiliar with the script, do not operate directly on the production server. After the test environment is confirmed to be correct, use it again! <br>
        The script is not confused with the code. It can be freely expanded according to its own business scenario. <br>

 [function description]<br>
        (1) Satisfy quick login command<br>
        (2) Connection Mode Selection: <br>
        Local mode:<br>
        (HOST:127.0.0.1) <br>
        Remote mode:<br>
        Manually set the specified IP and port number<br />
        (3) Basic check of configuration items:
        Local mode: The default basic redis configuration item provides some common security configuration checks (only basic configuration item checks are provided)
        Remote mode: check the port number configuration, do not provide cross-server (take into account the generality, security and other factors, temporarily upload this part of the function, there is a need to contact myself)
Validation mode: 0 Loose mode (only prompt or warning, process continues to execute); 1 Strict mode (error or warning to terminate the operation)



 [Next version plan]<br>
        (1). Script Status Processing <br>
        (2). Distributed redis instance management basics:<br>
        (3).Log module:<br>
        Increase the basic operation and maintenance script operation log log and error log tracking <br>
(4).redis instance status indicator monitoring <br><br><br>
 
 
 【Remarks】:<br />
        (1).Local configuration item processing: redis.conf: <br>
        The requirepass password is automatically fetched into the shell analysis to check if the password entry has been set to avoid manually setting a new password after the modification.
        (2).Do not provide automatic remote server password capture (mainly for permissions and security considerations), only provide some ideas<br>
The
Link: email:ceophp@163.com qq:404691073 (working frequently) 1099729311

        End!


<br>
(Usually busy work, will spare time to update, email or qq exchange at any time)<br>
