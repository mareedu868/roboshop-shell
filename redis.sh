source common.sh

print_head "Install redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "Enable redis 6.2 version"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "Installing redis"
yum install redis -y &>>${log_file}
status_check $?

print_head "Update listen address in redis config file"
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "Enable redis service"
systemctl enable redis
status_check $?

print_head "Starting redis service"
systemctl start redis
status_check $?