source common.sh
print_head "Creating mongodb repo file "
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Installing mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Enable mongodb service"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "Starting mongodb service"
systemctl start mongod &>>${log_file}
status_check $?

print_head "Replace 127.0.0.1 with 0.0.0.0 in /etc/mongod.conf"
sed -i "s/127.0.0.1/0.0.0.0/g"  /etc/mongod.conf &>>${log_file}
status_check $?

print_head "Restarting mongodb service"
systemctl restart mongod &>>${log_file}
status_check $?