#!/bin/bash

#-----------------------------------------------------
# 通用redis-cli终端运维管理快捷脚本 Version 1.0.0 
# File Name:	shortcut-redis-cli.sh
# Copyright:	2016 Jack Liu (Liu Jianqiu 秋)
# License:	MIT
# Version:	Version 1.0.0
# 
#
#  主要用途：
#　	不同运维场景快捷使用redis-cli终端
# Author: Jack Liu (Liu Jianqiu 秋)
# Email: ceophp@163.com
# Created Init By Date: 2016-03-18
#-----------------------------------------------------
# 【主要用途】
# 	不同运维场景下快捷使用redis-cli终端快捷连接中断
#
# 【免责声明】
#  如果对脚本不熟悉，请勿直接在生产服务器操作。待测试环境确认无误后再使用！
#  脚本不作代码混淆,根据自身业务场景自由扩展，测试无误后方可线上使用。
#
# 【功能说明】
# (1)满足快捷登入命令
#
# (2)连接模式选择:
#   本地模式：
#    (HOST:127.0.0.1) 
#   远程模式：
#    手动设置指定的IP和端口号
#
# (3)配置项基本检查：
#    本地模式：默认基本redis配置项提供部分通用安全配置检查(只提供基本配置项检查)
#    远程模式：检查端口号配置，不提供跨服务器(考虑通用性，安全等因素，暂时不放上传此部分功能，有需要联系本人)
# 
#
# Latest Update Date: 2016-10-21
#
# 【下一版本计划】
# 1.完善脚本执行验证和脚本状态处理
# 2.实现交互式选择管理远程目标服务器(在多服务器redis实例)
# 3.分布式redis实例管理基础:
#   增加一个redis进程服务器配置列表：$(pwd)/etc/server_list.conf(暂定名),提供交互
#   脚本提供至少三个参数命令：查看远程IP列表、查看脚本版本、查看
# 4.日志模块:
#   增加基本运维脚本操作log日志和错误日志跟踪
# 
# 
# 备注：
# 1.本地配置项处理:redis.conf: 
#    requirepass密码自动抓取到shell分析,检查密码项是否已设置,避免修改后手动设置新密码
# 2.不提供远程服务器密码自动抓取(主要出于权限和安全考虑)，只提供部分思路
# 
#    
#
#------------------------------------------------------



########## [参数设区 开始] ##########

#HOST设置(否为空)(host set)
redis_host="127.0.0.1"

#redis端口号设置,连接remote远程IP必须设置目标端口(redis port)
redis_port=6379

###redis (requirepass): auth身份验证密码设置(
# 留空表示未设置redis密码
#
## 本地管理模式：
#	可忽略此设置，留空则脚本自动获取本机requirepass
#
## 远程管理模式：
#	Romte远程IP如果未设置密码，此项留空即可
###
redis_requirepass=""

#redis.conf本地主配置文件路径设置(localhost)
local_redis_conf=/usr/local/redis/etc/redis.conf

#redis-cli: 终端命令路径设置(redis-cli path set)
redis_cli_path=/usr/local/redis/bin/redis-cli

#终端反馈标识设置
msg_conf=(
"Warnning(HOST:${redis_host})：远程IP服务器管理必须设置端口号！"
"Warnning(HOST:${redis_host})：redis-cli终端命令文件不存在，请确认文件所在路径后修改为实际所在路径！"
"Notice(HOST:${redis_host})：检测到当前redis连接端口号(Port)设置为默认:6379，生产服务器使用默认端口暴露在公网极容易被扫描攻击，建议修改为其他端口号！"
"Warnning(HOST:${redis_host})：redis验证密码未设置，如果服务器IP端口暴露在公网，请及时设置高强度redis身份验证密码！"
)

########## [参数设区 结束] ##########


########## [执行流程 (备注:如无特殊需要以下请勿修改)] ##########

#redis默认端口号()
redis_defaut_port=6379

#本地模式参数处理
if [ "${redis_host}" = "127.0.0.1" ]
then
	#如未手动设置验证密码则自动读取本地主配置文件requirepass设置重新赋值
	if [ -z "${redis_requirepass}" ]
	then
        	local_requirepass=`grep -E '^requirepass' ${local_redis_conf} | cut -d ' ' -f2`
		if [ -z "${local_requirepass}" ] || [ "${local_requirepass}" = "foobared" ]
		then
			local_requirepass=""
		fi
        	redis_requirepass=${local_requirepass}
	fi
	#如未手动设置端口号则自动读取本地主配置文件Port设置重新赋值
	if [ -z "${redis_port}" ]
	then
		local_port=`grep -E '^port' ${local_redis_conf} | cut -d ' ' -f2`
		if [ -z "${local_port}" ]
		then
			local_port=${redis_defaut_port}
		fi
		redis_port=${local_port}
	fi
else
	#远程模式(端口号)
	if [ -z "${redis_port}" ]
	then
        	echo ${msg_conf[0]}
		exit
	fi
fi

if [ ! -f "${redis_cli_path}" ]
then
	echo ${msg_conf[1]}
	exit
fi

if [ "${redis_port}" = 6379 ]
then
	echo ${msg_conf[2]}
fi

if [ -z "${redis_requirepass}" ]
then
	${redis_cli_path} -h ${redis_host} -p ${redis_port}
	echo ${msg_conf[3]}
	exit
else
	${redis_cli_path} -h ${redis_host} -p ${redis_port} -a "${redis_requirepass}"
	exit
fi

