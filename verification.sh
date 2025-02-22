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