-------------------------------------------------- -------\n
   Script Help Description\n--------------------------------------------- ------------\n\n

 Document Latest Update Date: 2016-11-01\n\n

Script parameters\n
        -v : View the current version of the script. \n\n

        -help : Check the help documentation. \n\n

        -list : Views the list of manageable instances and operates on the specified redis instance according to the number. \n\n
The
-c [Number] : An instance of a quick selection operation based on the number. \n\n

        
[main use]\n
        Easy to use redis-cli terminals in different O&M scenarios to manage redis instances\n\n

 [Disclaimer]\n
        If you are unfamiliar with the script, do not operate directly on the production server. After the test environment is confirmed to be correct, use it again! \n
        The script is not confused with the code. It can be freely expanded according to its own business scenario. \n\n

 [function description]\n
        (1) Satisfy quick login command\n
        (2) Connection mode selection:\n
        Local mode:\n
        (HOST:127.0.0.1) \n
        Remote mode:\n
        Manually set the specified IP and port number\n\n

        (3) Basic check of configuration items:\n
        Local mode: The default basic redis configuration item provides some common security configuration checks (only basic configuration item checks)\n
        Remote mode: check the port number configuration, do not provide cross-server (take into account the generality, security and other factors, temporarily upload this part of the function, there is a need to contact myself)\n\n
Validation mode: 0 Loose mode (only prompt or warning, process continues to execute); 1 Strict mode (error or warning to terminate the operation)

 Latest Update Date: 2016-10-21\n\n

 [Next version plan]\n
        (1). Script Status Processing\n
        (2). Distributed redis instance management basics:\n
        (3). Log module:\n
        Add basic operation and maintenance script operation log log and error log trace\n
(4).redis instance status indicator monitoring\n\n\n
 
 
 【Remarks】:\n
        (1).Local configuration item processing: redis.conf: \n
        The requirepass password is automatically fetched into shell analysis to check if the password entry has been set to avoid manually setting a new password after modification\n
        (2). Does not provide remote server password auto-crawl (mainly for permissions and security considerations), only provide some ideas\n\n
The
Link: email:ceophp@163.com qq:404691073 (working frequently) 1099729311 \n\n

        End!\n\n
