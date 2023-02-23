source common.sh

print_head "Install python 3.6"
yum install python36 gcc python3-devel -y &>>${log_file}
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

print_head "Downloading application code for payment"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>${log_file}
status_check $?

print_head "Extraction application code"
unzip /tmp/payment.zip
status_check $?

print_head "Install application dependencies and build application"
pip3.6 install -r requirements.txt &>>${log_file}
status_check $?

print_head "Creating payment service"
cp ${code_dir}/configs/payment.service /etc/systemd/system/payment.service &>>${log_file}
status_check $?

print_head "Reload systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable payment service"
systemctl enable payment &>>${log_file}
status_check $?

print_head "Start payment service"
systemctl start payment &>>${log_file}
status_check $?