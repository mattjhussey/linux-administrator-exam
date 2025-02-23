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

# Scenario OD/SCHED/4
echo "Scenario OD/SCHED/4"
# Verify that /opt/odsched4.sh is executable
if [ -x /opt/odsched4.sh ]; then
    echo -e "- \033[32m✓\033[0m /opt/odsched4.sh is executable"
else
    echo -e "- \033[31m✗\033[0m /opt/odsched4.sh is executable"
fi
# Verify that /opt/odsched4.sh has a shebang line
if head -n 1 /opt/odsched4.sh | grep -q "^#!/bin/bash"; then
    echo -e "- \033[32m✓\033[0m /opt/odsched4.sh has a shebang line"
else
    echo -e "- \033[31m✗\033[0m /opt/odsched4.sh has a shebang line"
fi
# Verify that /opt/odsched4.sh will copy /var/www/ to /opt/www-backup/ and preserve properties
if [ $(cat /opt/odsched4.sh | grep "cp -a /var/www/. /opt/www-backup/" | wc -l) -eq 1 ]; then
    echo -e "- \033[32m✓\033[0m /opt/odsched4.sh will copy /var/www/ to /opt/www-backup/ and preserve properties"
else
    echo -e "- \033[31m✗\033[0m /opt/odsched4.sh will copy /var/www/ to /opt/www-backup/ and preserve properties"
fi
# Verify that the system-wide /etc/crontab has an entry to execute /opt/odsched4.sh every day at 4AM under user root
if grep -q "0 4 \* \* \* root /opt/odsched4.sh" /etc/crontab; then
    echo -e "- \033[32m✓\033[0m The system-wide /etc/crontab has an entry to execute /opt/odsched4.sh every day at 4AM under user root"
else
    echo -e "- \033[31m✗\033[0m The system-wide /etc/crontab has an entry to execute /opt/odsched4.sh every day at 4AM under user root"
fi

# Scenario OD/PACK/1
echo "Scenario OD/PACK/1"
# Verify that the package 'tmux' is installed
if dpkg -l | grep -q "ii  tmux"; then
    echo -e "- \033[32m✓\033[0m The package 'tmux' is installed"
else
    echo -e "- \033[31m✗\033[0m The package 'tmux' is installed"
fi

# Scenario OD/PACK/2
echo "Scenario OD/PACK/2"
# Verify that links2 is installed in /usr/bin/links
if [ -f /usr/bin/links ]; then
    if [ $(readlink -f /usr/bin/links) == "/usr/bin/links" ]; then
        echo -e "- \033[32m✓\033[0m links2 is installed in /usr/bin/links"
    else
        echo -e "- \033[31m✗\033[0m links2 is installed in /usr/bin/links"
    fi
else
    echo -e "- \033[31m✗\033[0m links2 is installed in /usr/bin/links"
fi
# Verify that ipv6 is disabled for links
if [ $(links -dump -version 2>&1 | grep -c "ipv6") -eq 0 ]; then
    echo -e "- \033[32m✓\033[0m ipv6 is disabled for links"
else
    echo -e "- \033[31m✗\033[0m ipv6 is disabled for links"
fi

# Scenario OD/PACK/3
echo "Scenario OD/PACK/3"
# Verify that htop is installed on app-dev1 in /usr/local/bin
if ! sshpass -p examiner ssh examiner@app-dev1 "
    if [ -f /usr/local/bin/htop ]; then
        echo -e \"- \033[32m✓\033[0m htop is installed in /usr/local/bin\"
    else
        echo -e \"- \033[31m✗\033[0m htop is installed in /usr/local/bin\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to app-dev1"
fi

# Scenario OD/VIRT/1
echo "Scenario OD/VIRT/1"
# Verify that a virtual machine named 'mockexam2' exists and is configured to have 1 CPU, 1024MB of RAM, and uses ubuntu22.04 as the OS
if sudo virsh list --all | grep -q "mockexam2"; then
    if [ $(sudo virsh dominfo mockexam2 | grep "CPU(s)" | awk '{print $2}') -eq 1 ] && [ $(sudo virsh dominfo mockexam2 | grep "Max memory" | awk '{print $3}') -eq 1048576 ] && [ $(sudo virsh dominfo mockexam2 | grep "OS Type" | awk '{print $3}') == "hvm" ]; then
        echo -e "- \033[32m✓\033[0m A virtual machine named 'mockexam2' exists and is configured to have 1 CPU, 1024MB of RAM, and uses ubuntu22.04 as the OS"
    else
        echo -e "- \033[31m✗\033[0m A virtual machine named 'mockexam2' exists and is configured to have 1 CPU, 1024MB of RAM, and uses ubuntu22.04 as the OS"
    fi
else
    echo -e "- \033[31m✗\033[0m A virtual machine named 'mockexam2' exists and is configured to have 1 CPU, 1024MB of RAM, and uses ubuntu22.04 as the OS"
fi
# Verify that the virtual machine 'mockexam2' is set to auto start on boot
if [ "$(sudo virsh dominfo mockexam2 | grep "Autostart" | awk '{print $2}')" == "enable" ]; then
    echo -e "- \033[32m✓\033[0m The virtual machine 'mockexam2' is set to auto start on boot"
else
    echo -e "- \033[31m✗\033[0m The virtual machine 'mockexam2' is set to auto start on boot"
fi

# Scenario OD/DOCK/1
echo "Scenario OD/DOCK/1"
# Verify that docker container "frontend_v1" is stopped
if sudo docker ps -a | grep -q "frontend_v1"; then
    if [ $(sudo docker inspect -f '{{.State.Status}}' frontend_v1) == "exited" ]; then
        echo -e "- \033[32m✓\033[0m Docker container \"frontend_v1\" is stopped"
    else
        echo -e "- \033[31m✗\033[0m Docker container \"frontend_v1\" is stopped"
    fi
else
    echo -e "- \033[31m✗\033[0m Docker container \"frontend_v1\" is stopped"
fi
# Verify that docker container "frontenv_v2" is running
if sudo docker ps -a | grep -q "frontend_v2"; then
    if [ $(sudo docker inspect -f '{{.State.Status}}' frontend_v2) == "running" ]; then
        echo -e "- \033[32m✓\033[0m Docker container \"frontend_v2\" is running"
    else
        echo -e "- \033[31m✗\033[0m Docker container \"frontend_v2\" is running"
    fi
else
    echo -e "- \033[31m✗\033[0m Docker container \"frontend_v2\" is running"
fi
# Verify that the file /opt/oddock1/ip-address contains the IP address of the "frontend_v2" container
if [ -f /opt/oddock1/ip-address ]; then
    ip=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' frontend_v2)
    if [ $(cat /opt/oddock1/ip-address) == $ip ]; then
        echo -e "- \033[32m✓\033[0m The file /opt/oddock1/ip-address contains the IP address of the \"frontend_v2\" container"
    else
        echo -e "- \033[31m✗\033[0m The file /opt/oddock1/ip-address contains the IP address of the \"frontend_v2\" container"
    fi
else
    echo -e "- \033[31m✗\033[0m The file /opt/oddock1/ip-address contains the IP address of the \"frontend_v2\" container"
fi
# Verify that the file /opt/oddock1/mount-destination contains the mount destination of the "frontend_v2" container
if [ -f /opt/oddock1/mount-destination ]; then
    mount=$(sudo docker inspect -f '{{range .Mounts}}{{.Destination}}{{end}}' frontend_v2)
    if [ $(cat /opt/oddock1/mount-destination) == $mount ]; then
        echo -e "- \033[32m✓\033[0m The file /opt/oddock1/mount-destination contains the mount destination of the \"frontend_v2\" container"
    else
        echo -e "- \033[31m✗\033[0m The file /opt/oddock1/mount-destination contains the mount destination of the \"frontend_v2\" container"
    fi
else
    echo -e "- \033[31m✗\033[0m The file /opt/oddock1/mount-destination contains the mount destination of the \"frontend_v2\" container"
fi
# Verify that docker container "frontend_v3" is running
if sudo docker ps -a | grep -q "frontend_v3"; then
    if [ $(sudo docker inspect -f '{{.State.Status}}' frontend_v3) == "running" ]; then
        echo -e "- \033[32m✓\033[0m Docker container \"frontend_v3\" is running"
    else
        echo -e "- \033[31m✗\033[0m Docker container \"frontend_v3\" is running"
    fi
else
    echo -e "- \033[31m✗\033[0m Docker container \"frontend_v3\" is running"
fi
# Verify that docker container "frontend_v3" is using the "nginx:alpine" image
if [ $(sudo docker inspect -f '{{.Config.Image}}' frontend_v3) == "nginx:alpine" ]; then
    echo -e "- \033[32m✓\033[0m Docker container \"frontend_v3\" is using the \"nginx:alpine\" image"
else
    echo -e "- \033[31m✗\033[0m Docker container \"frontend_v3\" is using the \"nginx:alpine\" image"
fi
# Verify that docker container "frontend_v3" has a 30M memory limit
if [ $(sudo docker inspect -f '{{.HostConfig.Memory}}' frontend_v3) == 31457280 ]; then
    echo -e "- \033[32m✓\033[0m Docker container \"frontend_v3\" has a 30M memory limit"
else
    echo -e "- \033[31m✗\033[0m Docker container \"frontend_v3\" has a 30M memory limit"
fi
# Verify that docker container "frontend_v3" has port 1234 mapped to port 80
if sudo docker inspect frontend_v3 --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' | grep -q "1234"; then
    echo -e "- \033[32m✓\033[0m Docker container \"frontend_v3\" has port 1234 mapped to port 80"
else
    echo -e "- \033[31m✗\033[0m Docker container \"frontend_v3\" has port 1234 mapped to port 80"
fi

# Scenario OD/DOCK/2
echo "Scenario OD/DOCK/2"
# Verify that the docker image "bitnami/nginx" has been deleted
if ! sudo docker images | grep -q "bitnami/nginx"; then
    echo -e "- \033[32m✓\033[0m The docker image \"bitnami/nginx\" has been deleted"
else
    echo -e "- \033[31m✗\033[0m The docker image \"bitnami/nginx\" has been deleted"
fi
# Verify that a container with name "apache_container" based on the "httpd" image is running with port 8083 mapped to port 80 and set to restart only on failure up to 3 times
if sudo docker ps -a | grep -q "apache_container"; then
    if [ $(sudo docker inspect -f '{{.Config.Image}}' apache_container) == "httpd" ] && [ $(sudo docker inspect -f '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' apache_container) == "8083" ] && [ $(sudo docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' apache_container) == "on-failure" ] && [ $(sudo docker inspect -f '{{.HostConfig.RestartPolicy.MaximumRetryCount}}' apache_container) == 3 ]; then
        echo -e "- \033[32m✓\033[0m A container with name \"apache_container\" based on the \"httpd\" image is running with port 8083 mapped to port 80 and set to restart only on failure up to 3 times"
    else
        echo -e "- \033[31m✗\033[0m A container with name \"apache_container\" based on the \"httpd\" image is running with port 8083 mapped to port 80 and set to restart only on failure up to 3 times"
    fi
else
    echo -e "- \033[31m✗\033[0m A container with name \"apache_container\" based on the \"httpd\" image is running with port 8083 mapped to port 80 and set to restart only on failure up to 3 times"
fi

# Scenario OD/SEL/1
echo "Scenario OD/SEL/1"
# Verify that the file /opt/odsel1/selinuxmode.txt contains the string "permissive"
if [ -f /opt/odsel1/selinuxmode.txt ]; then
    if [ $(cat /opt/odsel1/selinuxmode.txt) == "Permissive" ]; then
        echo -e "- \033[32m✓\033[0m The file /opt/odsel1/selinuxmode.txt contains the string \"permissive\""
    else
        echo -e "- \033[31m✗\033[0m The file /opt/odsel1/selinuxmode.txt contains the string \"permissive\""
    fi
else
    echo -e "- \033[31m✗\033[0m The file /opt/odsel1/selinuxmode.txt contains the string \"permissive\""
fi
# Verify that /usr/bin/less on web-srv2 has the correct selinux context
if ! sshpass -p examiner ssh examiner@web-srv2 "
    if [ \$(ls -Z /usr/bin/less | awk '{print \$1}') == \"system_u:object_r:bin_t:s0\" ]; then
        echo -e \"- \033[32m✓\033[0m /usr/bin/less has the correct selinux context\"
    else
        echo -e \"- \033[31m✗\033[0m /usr/bin/less has the correct selinux context\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv2"
fi

# Scenario OD/SEL/2
echo "Scenario OD/SEL/2"
# Verify that /home/student/odsel2perms.txt on web-srv2 has the SELinux user context "init_exec_t"
if ! sshpass -p examiner ssh examiner@web-srv2 "
    if [ \$(ls -Z /opt/odsel2/perms.txt | awk -F: '{print \$3}') == \"init_exec_t\" ]; then
        echo -e \"- \033[32m✓\033[0m /opt/odsel2/perms.txt has the SELinux user context 'init_exec_t'\"
    else
        echo -e \"- \033[31m✗\033[0m /opt/odsel2/perms.txt has the SELinux user context 'init_exec_t'\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv2"
fi
# Verify that /opt/odsel2/seenabled.txt on web-srv2 contains an SELinux sestatus output reporting containing "enabled"
if ! sshpass -p examiner ssh examiner@web-srv2 "
    if [ \$(cat /opt/odsel2/seenabled.txt | grep -c \"enforcing\") -eq 1 ]; then
        echo -e \"- \033[32m✓\033[0m /opt/odsel2/seenabled.txt contains an SELinux sestatus output reporting containing 'enforcing'\"
    else
        echo -e \"- \033[31m✗\033[0m /opt/odsel2/seenabled.txt contains an SELinux sestatus output reporting containing 'enforcing'\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv2"
fi
# Verify that SELinux on web-srv2 is in permissive mode
if ! sshpass -p examiner ssh examiner@web-srv2 "
    if [ \$(sestatus | grep \"Current mode\" | grep -c \"permissive\") -eq 1 ]; then
        echo -e \"- \033[32m✓\033[0m SELinux on web-srv2 is in permissive mode\"
    else
        echo -e \"- \033[31m✗\033[0m SELinux on web-srv2 is in permissive mode\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv2"
fi

# Scenario OD/SEL/3
echo "Scenario OD/SEL/3"
# Verify that SE Boolean httpd_use_nfs is enabled on web-srv2
if ! sshpass -p examiner ssh examiner@web-srv2 "
    if [ \$(getsebool httpd_use_nfs | awk '{print \$3}') == \"on\" ]; then
        echo -e \"- \033[32m✓\033[0m SE Boolean httpd_use_nfs is enabled\"
    else
        echo -e \"- \033[31m✗\033[0m SE Boolean httpd_use_nfs is enabled\"
    fi
"; then
    echo -e "- \033[31m✗\033[0m Failed to connect to web-srv2"
fi