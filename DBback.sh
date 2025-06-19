#!/bin/bash
# 定义备份用户/密码
DbUser=root
DbPasswd=6789@jkL

# 定义备份数据库
DbName=("zabbix" "jumpserver" "openfire")
# 定义备份目录
Path=/daSQL
# 定义备份数据保存天数 Mtime=3+1 天数也就是4天
Mtime=3

Time=$(date +%F)
CurrentPath=$(pwd)

if ! [ -d ${Path} ];then
    mkdir ${Path}
fi

for i in ${DbName[@]};do
    if [ -d ${Path}/${Time} ];then
        cd ${Path}/${Time}
    else
        mkdir ${Path}/${Time} && cd ${Path}/${Time}
    fi
    mysqldump -f -x  -u${DbUser} -p${DbPasswd} ${i} >${i}.sql
    zip ${i}.zip ${i}.sql
    rm -f ${i}.sql
done

cd ${Path} && find ${Path} -name '*.sql' -mtime +${Mtime}|awk -F"/" '{print $3}'|xargs rm -rf

# 定时任务 自动添加
if ! (grep -r ${CurrentPath}/${0} /var/spool/cron/root &>/dev/null);then
	echo >> /var/spool/cron/root
	echo "#DBServer: Backup Database" >> /var/spool/cron/root
    echo "0 1 * * * bash ${CurrentPath}/${0} >> db_backup.log" >> /var/spool/cron/root
fi
