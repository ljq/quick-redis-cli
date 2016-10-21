### shortcut-redis-cli ###

## 通用redis-cli终端运维管理快捷脚本 Version 1.0.0 ( 脚本最后更新时间:2016-10-21 ) ##
 File Name:    shortcut-redis-cli.sh <br>
 Copyright:    2016 Jack Liu (Liu Jianqiu 秋)<br>
 License:      MIT<br>
 Version:      Version 1.0.0<br>
 
 Author: Jack Liu (Liu Jianqiu 秋)<br>
 Email: ceophp@163.com<br>
 Created Init By Date: 2016-03-18<br>

## 【主要用途】##
   不同运维场景下快捷使用redis-cli终端连接

## 【免责声明】##
*  如果对脚本不熟悉，请勿直接在生产服务器操作。待测试环境确认无误后再使用！
*  脚本不作代码混淆,根据自身业务场景自由扩展，测试无误后方可线上使用。

## 【主要功能点】##
 (1)满足快捷使用redis-cli连接任何一台redis实例（有或无requirepass密码）<br>

 (2)连接模式选择:<br>
   本地模式：<br>
    (HOST:127.0.0.1)<br> 
   远程模式：<br>
    手动设置指定的IP和端口号(必选项)<br>

 (3)配置项基本检查：<br>
    本地模式：默认基本redis配置项提供部分通用安全配置检查(只提供基本配置项检查)<br>
    远程模式：检查端口号配置，不提供跨服务器(考虑通用性，安全等因素，暂时不放上传此部分功能，有需要联系本人)<br>

## 【下一版本计划】##
 1.完善脚本执行验证和脚本状态处理<br>
 2.实现交互式选择管理远程目标服务器(在多服务器redis实例)<br>
 3.分布式redis实例管理基础:<br>
   增加一个redis进程服务器配置列表：$(pwd)/etc/server_list.conf(暂定名),提供交互<br><br>
   脚本提供至少三个参数命令：查看远程IP列表、查看脚本版本、查看<br>
 4.日志模块:<br>
   增加基本运维脚本操作log日志和错误日志跟踪<br>
 
 
    


