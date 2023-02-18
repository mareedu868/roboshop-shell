code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -rf ${log_file}

print_head() {
  echo -e "\e[36m$1\e[0m"
}

print_head "Installing nginx"

yum install nginx -y &>>${log_file}

print_head "Removing Old content"

rm -rf /usr/share/nginx/html/*

print_head "Downloading Frontend zip file"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

cd /usr/share/nginx/html

print_head "Extracting Frontend code"

unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying Roboshop Configuration"
pwd
ls -ltr

cp $(code_dir)/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

print_head "Enabling and Restarting nginx"

systemctl enable nginx &>>${log_file}

systemctl restart nginx
