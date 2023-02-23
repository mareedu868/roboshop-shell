source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}
status_check $?

print_head "Removing Old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_head "Downloading Frontend zip file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?
cd /usr/share/nginx/html &>>${log_file}
status_check $?

print_head "Extracting Frontend code"
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head "Copying Roboshop Configuration"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_head "Enabling and Restarting nginx"
systemctl enable nginx &>>${log_file}
status_check $?

systemctl restart nginx &>>${log_file}
status_check $?
