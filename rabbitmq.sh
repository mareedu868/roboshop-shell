source common.sh

print_head "Configure yum repo for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Install erlang"
yum install erlang -y &>>${log_file}
status_check $?

print_head "Configure yum repo for rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Install rabbitmq"
yum install rabbitmq-server -y &>>${log_file}
status_check $?

print_head "Enable rabbitmaq service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "Start rabbitmaq service"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "Create roboshop user"

#rabbitmqctl add_user roboshop roboshop123
#rabbitmqctl set_user_tags roboshop administrator
#rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
