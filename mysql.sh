source common.sh

print_head "Disable mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Create mysql repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Install mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable mysql service"
systemctl enable mysqld
status_check $?

print_head "Start mysql service"
systemctl start mysqld
status_check $?

print_head "Set mysql root password"
echo "show databases mysql -uroot -p$1"
if [$? -ne 0 ]; then
  mysql_secure_installation --set-root-pass $1
fi
status_check $?