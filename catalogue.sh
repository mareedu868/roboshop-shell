source common.sh

print_head "Set up nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Adding application user"
useradd roboshop &>>${log_file}
status_check $?

print_head "Creating app directory"
mkdir /app &>>${log_file}
status_check $?

print_head "Download application code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?

print_head "Change to app directory"
cd /app
status_check $?

print_head "Extract application code"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "Install application dependencies"
npm install &>>${log_file}
status_check $?

print_head "Setup systemd service"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "System daemon reload"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable catalogue service"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "Start catalogue service"
systemctl start catalogue &>>${log_file}
status_check $?

print_head "Create mongodb repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install mongodb client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load schema to mongodb"
mongo --host mongodb.mydevopslearning.online </app/schema/catalogue.js &>>${log_file}
status_check $?

