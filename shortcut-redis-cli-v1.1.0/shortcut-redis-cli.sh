#!/bin/bash

#-----------------------------------------------------
# 通用redis-cli终端运维管理快捷脚本 Version 1.0.0 
# File Name:	shortcut-redis-cli.sh
# Copyright:	2016 Jack Liu (Liu Jianqiu 秋)
# License:	MIT
# Version:	Version 1.1.0
# 
#  主要用途：
#　	不同运维场景快捷使用redis-cli终端
# Author: Jack Liu (Liu Jianqiu 秋)
# Email: ceophp@163.com
# Created Init By Date: 2016-03-18
#------------------------------------------------------


#---------- [配置参数设区 开始] ----------

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

#严格模式(0 宽松模式(默认) 1 严格模式)
strict_mode=0;

#密码长度设置(默认10-50)
pass_min_length=10
pass_max_length=50


#-----(以下参数无特殊需要不建议修改)----------

#版本号(请勿修改)
sh_version="Version: 1.1.0 Created By Date 2016."

#配置文件目录(默认取脚本所在路径下的配置文件)
shortcut_conf=$(pwd)/etc

#管理实例列表配置
server_list_conf=${shortcut_conf}/server_list.conf

#帮助文档
shortcut_doc=${shortcut_conf}/README

#终端反馈标识设置
msg_conf=(
"Warnning(HOST:REDIS_HOST)：远程IP服务器管理必须设置端口号！"
"Warnning(HOST:REDIS_HOST)：redis-cli终端命令文件不存在，请确认文件所在路径后修改为实际所在路径！"
"Notice(HOST:REDIS_HOST)检测到当前redis连接端口号(Port)设置为默认:6379，生产服务器使用默认端口暴露在公网极容易被扫描攻击，建议修改为其他端口号！"
"Warnning(HOST:REDIS_HOST)：redis验证密码未设置，如果服务器IP端口暴露在公网，请及时设置高强度redis身份验证密码！"
"Warnning(HOST:REDIS_HOST)：redis密码长度设置过于简单，设置长度范围介于(${pass_min_length}-${pass_max_length})之间!"
"Warnning(HOST:REDIS_HOST)：操作已被终止！"
": 请选择要操作的实例编号? (编号范围:0-TOTAL_SERVER_LIST, 输入no直接退出)"
"输入编号范围不合法！"
"未指定参数值！"
"警告：传入参数\" INPUT \"值有误或暂不支持！请参阅帮助文档。"
)  

#---------- [配置参数设区 结束] ----------


#---------- [命令参数处理 开始 ----------

argv_1="${1}"
case ${argv_1} in
	"-v"):
		echo $sh_version
		exit
	;;
	"-help"):
		echo -e `cat ${shortcut_doc} | awk '{printf $0}'`
		exit
	;;
        "-list"):
		server_list=(`cat "${server_list_conf}" | sed -e '/^$/d' | sed -e '/^#/d'`)
		echo -e "+--------------------------- (Redis实例管理列表管理) ---------------------------+"
		echo -e "编号(No) IP实例\t\t 端口(port)\t 密码(requirepass)"
		total_server_list=${#server_list[@]}
		for((no=0;no<${total_server_list};no++))
		do
			#获取实例配置
			OLD_IFS="$IFS" 
			IFS=":" 
			list_item=(${server_list[$no]}) 
			IFS="$OLD_IFS"
    			echo -e ${no}":\t "${list_item[0]}";\t port: "${list_item[1]}";\t requirepass: "${list_item[2]}
		done
		echo -e "+------------------------------- (共"${total_server_list}"个可管理实例) -----------------------------+"
		echo ${msg_conf[6]//"TOTAL_SERVER_LIST"/${total_server_list}}
		read SERVER_NO
		#非数字直接终止
		if [[ ! "${SERVER_NO}" =~ "^[0-9]+$" ]]
		then
			exit
		fi
		if [ ${SERVER_NO} > ${total_server_list} ] || [ {$SERVER_NO} < 0 ]
		then
			echo ${msg_conf[7]}
			exit
		fi
		#选择配置赋值
		OLD_IFS="$IFS"
                IFS=":"
                list_item_no=(${server_list[$SERVER_NO]})
		IFS="$OLD_IFS"
		redis_host=${list_item_no[0]}
		redis_port=${list_item_no[1]}
		redis_requirepas=${list_item_no[2]}
        ;;
	"-c"):
		#选择指定配置序列号
		if [ ! -n "$2" ]
		then
			echo "-c: "${msg_conf[8]}
			exit
		fi
		choice_no=${2}
		server_list=(`cat "${server_list_conf}" | sed -e '/^$/d'`)
		total_server_list=${#server_list[@]}
		
		if [ "${choice_no}" -gt ${total_server_list} ] || [ "${choice_no}" -lt 0 ]
                then
                        echo ${msg_conf[7]}
                        eixt
                fi
	        OLD_IFS="$IFS"
                IFS=":"
                list_item_no=(${server_list[$choice_no]})
                IFS="$OLD_IFS"
                redis_host=${list_item_no[0]}
                redis_port=${list_item_no[1]}
                redis_requirepas=${list_item_no[2]}
	;;
	*):
		if [ "${1}" ]
		then
			echo -e `cat ${shortcut_doc} | awk '{printf $0}'`
			echo -e ${msg_conf[9]//"INPUT"/${1}}"\n\n"
        		exit
		fi
	;;
esac

#---------- [命令参数处理 结束] ----------



#---------- [执行流程 (备注:如无特殊需要以下请勿修改)] ----------

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
	#远程IP模式(端口号)
	if [ -z "${redis_port}" ]
	then
        	echo ${msg_conf[0]//"REDIS_HOST"/${redis_host}}
		exit
	fi
fi

if [ ! -f "${redis_cli_path}" ]
then
	echo ${msg_conf[1]//"REDIS_HOST"/${redis_host}}
	exit
fi

if [ "${redis_port}" = 6379 ]
then
	echo ${msg_conf[2]//"REDIS_HOST"/${redis_host}}
fi

if [ -z "${redis_requirepass}" ]
then
	${redis_cli_path} -h ${redis_host} -p ${redis_port}
	echo ${msg_conf[3]//"REDIS_HOST"/${redis_host}}
	exit
else
	#requirepass检查
	if [[ ! "{$redis_requirepass}" =~ "(?=^.{"${pass_min_length}","${pass_max_length}"}$)" ]]
	then
		echo ${msg_conf[4]//"REDIS_HOST"/${redis_host}}
		if [ "${strict_mode}" = 1 ]
		then
			echo ${msg_conf[5]//"REDIS_HOST"/${redis_host}}
			exit
		fi
	fi
	${redis_cli_path} -h ${redis_host} -p ${redis_port} -a "${redis_requirepass}"
	exit
fi

