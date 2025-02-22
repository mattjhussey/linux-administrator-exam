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