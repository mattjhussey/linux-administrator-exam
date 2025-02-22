#!/bin/bash

# Scenario OD/KP/1
echo "Scenario OD/KP/1"
# Verify that vm.swappiness is 10
swappiness=$(cat /proc/sys/vm/swappiness)
if [ $swappiness -eq 10 ]; then
    echo -e "- \033[32m✓\033[0m vm.swappiness is 10"
else
    echo -e "- \033[31m✗\033[0m vm.swappiness is 10"
fi
# Verify that vm.swappiness is set to 10 in /etc/sysctl.conf
swappiness=$(grep "vm.swappiness" /etc/sysctl.conf | awk '{print $3}')
if [ $swappiness -eq 10 ]; then
    echo -e "- \033[32m✓\033[0m vm.swappiness is set to 10 in /etc/sysctl.conf"
else
    echo -e "- \033[31m✗\033[0m vm.swappiness is set to 10 in /etc/sysctl.conf"
fi

# Scenario OD/KP/2
echo "Scenario OD/KP/2"
# Verify that the current Linux Kernel release is in /opt/course/od/kp/2/kernel
kernel=$(uname -r)
if [ -f /opt/course/od/kp/2/kernel ]; then
    if [ $(cat /opt/course/od/kp/2/kernel) == $kernel ]; then
        echo -e "- \033[32m✓\033[0m The current Linux Kernel release is in /opt/course/od/kp/2/kernel"
    else
        echo -e "- \033[31m✗\033[0m The current Linux Kernel release is in /opt/course/od/kp/2/kernel"
    fi
else
    echo -e "- \033[31m✗\033[0m The current Linux Kernel release is in /opt/course/od/kp/2/kernel"
fi
# Verify that the current `ip_forward` kernel parameter is stored in /opt/course/od/kp/2/ip_forward
ip_forward=$(cat /proc/sys/net/ipv4/ip_forward)
if [ -f /opt/course/od/kp/2/ip_forward ]; then
    if [ $(cat /opt/course/od/kp/2/ip_forward) == $ip_forward ]; then
        echo -e "- \033[32m✓\033[0m The current ip_forward kernel parameter is stored in /opt/course/od/kp/2/ip_forward"
    else
        echo -e "- \033[31m✗\033[0m The current ip_forward kernel parameter is stored in /opt/course/od/kp/2/ip_forward"
    fi
else
    echo -e "- \033[31m✗\033[0m The current ip_forward kernel parameter is stored in /opt/course/od/kp/2/ip_forward"
fi
# Verify that the current system timezone is stored in /opt/course/od/kp/2/timezone
timezone=$(timedatectl | grep "Time zone" | awk '{print $3}')
if [ -f /opt/course/od/kp/2/timezone ]; then
    if [ $(cat /opt/course/od/kp/2/timezone) == $timezone ]; then
        echo -e "- \033[32m✓\033[0m The current system timezone is stored in /opt/course/od/kp/2/timezone"
    else
        echo -e "- \033[31m✗\033[0m The current system timezone is stored in /opt/course/od/kp/2/timezone"
    fi
else
    echo -e "- \033[31m✗\033[0m The current system timezone is stored in /opt/course/od/kp/2/timezone"
fi

# Scenario OD/PROC/1
echo "Scenario OD/PROC/1"
# Verify all conditions by running commands through SSH on web-srv1
if ! sshpass -p examiner ssh examiner@web-srv1 "
    # Check if the collector2 process is running
    ps -ef | grep collector2 | grep -v grep > /dev/null 2>&1
    if [ \$? -eq 1 ]; then
        echo -e \"- \033[32m✓\033[0m The faulty process is not running\"
    else
        echo -e \"- \033[31m✗\033[0m The faulty process is not running\"
    fi

    # Check it /usr/local/bin/collector2 has been deleted
    if [ ! -f /usr/local/bin/collector2 ]; then
        echo -e \"- \033[32m✓\033[0m The faulty binary has been deleted\"
    else
        echo -e \"- \033[31m✗\033[0m The faulty binary has been deleted\"
    fi

    # Check if the collector1 AND collecto3 processes are running
    ps -ef | grep collector1 | grep -v grep > /dev/null 2>&1
    status1=\$?
    ps -ef | grep collector3 | grep -v grep > /dev/null 2>&1
    status3=\$?
    if [ \$status1 -eq 0 ] && [ \$status3 -eq 0 ]; then
        echo -e \"- \033[32m✓\033[0m The working processes are running\"
    else
        echo -e \"- \033[31m✗\033[0m The working processes are running\"
    fi

    # Check if /usr/local/bin/collector1 AND /usr/local/bin/collector3 exist
    if [ -f /usr/local/bin/collector1 ] && [ -f /usr/local/bin/collector3 ]; then
        echo -e \"- \033[32m✓\033[0m The working binaries exist\"
    else
        echo -e \"- \033[31m✗\033[0m The working binaries exist\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv1"
fi

# Scenario OD/PROC/2
echo "Scenario OD/PROC/2"
# Verify that `/dev/sdc` is formatted with `ext4`
filesystem=$(lsblk -f | grep sdc | awk '{print $2}')
if [ $filesystem == "ext4" ]; then
    echo -e "- \033[32m✓\033[0m /dev/sdc is formatted with ext4"
else
    echo -e "- \033[31m✗\033[0m /dev/sdc is formatted with ext4"
fi
# Verify that `/dev/sdc` is mounted on `/mnt/backup-black`
mountpoint=$(df -h | grep sdc | awk '{print $6}')
if [ $mountpoint == "/mnt/backup-black" ]; then
    echo -e "- \033[32m✓\033[0m /dev/sdc is mounted on /mnt/backup-black"
else
    echo -e "- \033[31m✗\033[0m /dev/sdc is mounted on /mnt/backup-black"
fi
# Verify that the file `/mnt/backup-black/completed` exists
if [ -f /mnt/backup-black/completed ]; then
    echo -e "- \033[32m✓\033[0m /mnt/backup-black/completed exists"
else
    echo -e "- \033[31m✗\033[0m /mnt/backup-black/completed exists"
fi
# Verify that the /mnt/od_proc2_2/.trash directory exists
if [ -d /mnt/od_proc2_2/.trash ]; then
    echo -e "- \033[32m✓\033[0m /mnt/odproc2_2/.trash exists"
else
    echo -e "- \033[31m✗\033[0m /mnt/od_proc2_2/.trash exists"
fi
# Verify that the /mnt/od_proc2_2/.trash directory is empty
trash=$(ls -A /mnt/odproc2_2/.trash)
if [ -z "$trash" ]; then
    echo -e "- \033[32m✓\033[0m /mnt/odproc2_2/.trash is empty"
else
    echo -e "- \033[31m✗\033[0m /mnt/odproc2_2/.trash is empty"
fi
# Verify that the /mnt/od_proc2_1/.trash directory exists
if [ -d /mnt/od_proc2_1/.trash ]; then
    echo -e "- \033[32m✓\033[0m /mnt/odproc2_1/.trash exists"
else
    echo -e "- \033[31m✗\033[0m /mnt/odproc2_1/.trash exists"
fi
# Verify that the /mnt/od_proc2_1/.trash directory is not empty
trash=$(ls -A /mnt/odproc2_1/.trash)
if [ -z "$trash" ]; then
    echo -e "- \033[31m✗\033[0m /mnt/odproc2_1/.trash is not empty"
else
    echo -e "- \033[32m✓\033[0m /mnt/odproc2_1/.trash is not empty"
fi
# Verify that /mnt/odproc2_4/dark-matter2 is not running
ps -ef | grep dark-matter-2 | grep -v grep > /dev/null 2>&1
if [ $? -eq 1 ]; then
    echo -e "- \033[32m✓\033[0m dark-matter-2 is not running"
else
    echo -e "- \033[31m✗\033[0m dark-matter-2 is not running"
fi

# Verify that /mnt/odproc2_4 is unmounted
mountpoint=$(df -h | grep odproc2_4 | awk '{print $6}')
if [ -z "$mountpoint" ]; then
    echo -e "- \033[32m✓\033[0m High utilisation disk: /mnt/odproc2_4 is unmounted"
else
    echo -e "- \033[31m✗\033[0m High utilisation disk: /mnt/odproc2_4 is unmounted"
fi

# Scenario OD/PROC/3
echo "Scenario OD/PROC/3"
# Verify that the httpd service on web-srv2 is not running
if ! sshpass -p examiner ssh examiner@web-srv2 "
    systemctl is-active httpd > /dev/null 2>&1
    if [ \$? -eq 3 ]; then
        echo -e \"- \033[32m✓\033[0m The httpd service is not running\"
    else
        echo -e \"- \033[31m✗\033[0m The httpd service is not running\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv2"
fi
# Verify that the httpd service on web-srv2 is disabled
if ! sshpass -p examiner ssh examiner@web-srv2 "
    systemctl is-enabled httpd > /dev/null 2>&1
    if [ \$? -eq 1 ]; then
        echo -e \"- \033[32m✓\033[0m The httpd service is disabled\"
    else
        echo -e \"- \033[31m✗\033[0m The httpd service is disabled\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv2"
fi

# Scenario OD/PROC/4
echo "Scenario OD/PROC/4"
# Verify that the first line of the file /opt/odproc4.txt is the string "nginx"
if [ $(head -n 1 /opt/odproc4.txt) == "nginx" ]; then
    echo -e "- \033[32m✓\033[0m The first line of /opt/odproc4.txt is the string \"nginx\""
else
    echo -e "- \033[31m✗\033[0m The first line of /opt/odproc4.txt is the string \"nginx\""
fi
# Verify that the second line of the file /opt/odproc4.txt is pid of the nginx master process
pid=$(ps -ef | grep nginx | grep master | awk '{print $2}')
if [ $(sed -n '2p' /opt/odproc4.txt) == $pid ]; then
    echo -e "- \033[32m✓\033[0m The second line of /opt/odproc4.txt is the pid of the nginx master process"
else
    echo -e "- \033[31m✗\033[0m The second line of /opt/odproc4.txt is the pid of the nginx master process"
fi

# Scenario OD/PROC/5
echo "Scenario OD/PROC/5"
# Verify that nginx is running on web-srv3
if ! sshpass -p examiner ssh examiner@web-srv3 "
    ps -ef | grep nginx | grep -v grep > /dev/null 2>&1
    if [ \$? -eq 0 ]; then
        echo -e \"- \033[32m✓\033[0m nginx is running\"
    else
        echo -e \"- \033[31m✗\033[0m nginx is running\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv3"
fi
# Verify that the nginx service is enabled on web-srv3
if ! sshpass -p examiner ssh examiner@web-srv3 "
    systemctl is-enabled nginx > /dev/null 2>&1
    if [ \$? -eq 0 ]; then
        echo -e \"- \033[32m✓\033[0m The nginx service is enabled\"
    else
        echo -e \"- \033[31m✗\033[0m The nginx service is enabled\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv3"
fi
# Verify that the nginx service is configured to start on boot on web-srv3
if ! sshpass -p examiner ssh examiner@web-srv3 "
    systemctl is-enabled nginx > /dev/null 2>&1
    if [ \$? -eq 0 ]; then
        echo -e \"- \033[32m✓\033[0m The nginx service is configured to start on boot\"
    else
        echo -e \"- \033[31m✗\033[0m The nginx service is configured to start on boot\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv3"
fi
# Verify that /opt/odproc5.txt contains the string "www-data"
if [ $(cat /opt/odproc5.txt) == "www-data" ]; then
    echo -e "- \033[32m✓\033[0m /opt/odproc5.txt contains the string \"www-data\""
else
    echo -e "- \033[31m✗\033[0m /opt/odproc5.txt contains the string \"www-data\""
fi

# Scenario OD/SCHED/1
echo "Scenario OD/SCHED/1"
# Verify that there is a cron job scheduled to kill all processes named "scan_filesystem" every minute as root
if sudo crontab -l -u root | grep -q "^\* \* \* \* \* killall -9 scan_filesystem"; then
    echo -e "- \033[32m✓\033[0m There is a cron job scheduled to kill all processes named \"scan_filesystem\" every minute"
else
    echo -e "- \033[31m✗\033[0m There is a cron job scheduled to kill all processes named \"scan_filesystem\" every minute"
fi

# Scenario OD/SCHED/2
echo "Scenario OD/SCHED/2"
# Verify that there is no system-wide cronjob to run clean.sh
if ! grep -r "clean.sh" /etc/cron.* /etc/crontab > /dev/null 2>&1; then
    echo -e "- \033[32m✓\033[0m There is no system-wide cronjob to run clean.sh"
else
    echo -e "- \033[31m✗\033[0m There is no system-wide cronjob to run clean.sh"
fi
# Verify that user asset-manager has a cronjob to run /home/asset-manager/clean.sh at 11:15AM every Monday and Thursday
if sudo crontab -l -u asset-manager | grep -q "^15 11 \* \* 1,4 /home/asset-manager/clean.sh"; then
    echo -e "- \033[32m✓\033[0m User asset-manager has a cronjob to run /home/asset-manager/clean.sh at 11:15AM every Monday and Thursday"
else
    echo -e "- \033[31m✗\033[0m User asset-manager has a cronjob to run /home/asset-manager/clean.sh at 11:15AM every Monday and Thursday"
fi

# Scenario OD/SCHED/3
echo "Scenario OD/SCHED/3"
# Verify that there is a cron job for user asset-manager scheduled to run every Wednedsday at 4AM and calls `find /home/asset-manager/ -type d -empty -delete`
if sudo crontab -l -u asset-manager | grep -q "^0 4 \* \* 3 find /home/asset-manager/ -type d -empty -delete"; then
    echo -e "- \033[32m✓\033[0m There is a cron job for user asset-manager scheduled to run every Wednesday at 4AM and calls find /home/asset-manager/ -type d -empty -delete"
else
    echo -e "- \033[31m✗\033[0m There is a cron job for user asset-manager scheduled to run every Wednesday at 4AM and calls find /home/asset-manager/ -type d -empty -delete"
fi
