source common.sh
print_head "Downloading nodejs rpm"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash >>${log_file} 2>>${err_file}
print_head "Installing nodejs"
yum install nodejs -y >>${log_file} 2>>${err_file}
useradd roboshop
mkdir /app
rm -rf /app/*
print_head "Downloading catalogue code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip >>${log_file} 2>>${err_file}
cd /app
print_head "Extracting catalogue code"
unzip /tmp/catalogue.zip >>${log_file} 2>>${err_file}
print_head "Installing catalogue code"
npm install >>${log_file} 2>>${err_file}
print_head "Creating catalogue service"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service >>${log_file} 2>>${err_file}
print_head "Reloading daemon service process"
systemctl daemon-reload >>${log_file} 2>>${err_file}
print_head "Enabling catalogue service"
systemctl enable catalogue >>${log_file} 2>>${err_file}
print_head "Restarting catalogue service"
systemctl restart catalogue >>${log_file} 2>>${err_file}
print_head "Creating mongodb repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo >>${log_file} 2>>${err_file}
print_head "Installing mongodb client"
yum install mongodb-org-shell -y >>${log_file} 2>>${err_file}
print_head "loading catalogue schema"
mongo --host mongodb.mydevopslearning.online </app/schema/catalogue.js >>${log_file} 2>>${err_file}