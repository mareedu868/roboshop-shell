source common.sh

print_head "Installing maven"
yum install maven -y &>>${log_file}
status_check $?

print_head "Creating roboshop user"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
useradd roboshop
fi
status_check $?

print_head "Creating app directory"
if [ ! -d /app ]; then
mkdir /app
fi
status_check $?

print_head "Removing old content in app directory"
rm -rf /app/* &>>{log_file}
status_check $?

print_head "Change directory to app"
cd /app
status_check $?

print_head "Downloading application code for shipping"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>${log_file}
status_check $?

print_head "Extraction application code"
unzip /tmp/shipping.zip
status_check $?

print_head "Install application dependencies and build application"
mvn clean package &>>${log_file}
status_check $?

print_head "Moving jar file from target to app directory"
mv target/shipping-1.0.jar shipping.jar &>>${log_file}
status_check $?

print_head "Creating shipping service"
cp ${code_dir}/configs/shipping.service /etc/systemd/system/shipping.service &>>${log_file}
status_check $?

print_head "Reload systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable shipping service"
systemctl enable shipping &>>${log_file}
status_check $?



print_head "Install mysql to load schema"
yum install mysql -y &>>${log_file}
status_check $?

print_head "Load schema"
mysql -h mysql.mydevopslearning.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
status_check $?

print_head "Start shipping service"
systemctl start shipping &>>${log_file}
status_check $?