code_dir=$(pwd)
log_file=/tmp/roboshop.log
err_file=/tmp/roboerr.log
rm -rf ${log_file}

print_head() {
  echo -e "\e[34m$1\e[0m"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo "SUCCESS"
  else
    echo "Failure"
    echo "Please refer ${log_file} for more information on the error"
    exit 1
  fi
}

#nodejs() {
  print_head "Downloading nodejs rpm"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  print_head "Installing nodejs"
  yum install nodejs -y &>>${log_file}
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

  print_head "Downloading ${component} code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?

  print_head "Extracting ${component} code"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?

  print_head "Installing ${component} code"
  npm install &>>${log_file}
  status_check $?

  print_head "Creating ${component} service"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?

  print_head "Reloading daemon service process"
  systemctl daemon-reload &>>${log_file}
  status_check $?

  print_head "Enabling ${component} service"
  systemctl enable ${component} &>>${log_file}
  status_check $?

  print_head "Starting ${component} service"
  systemctl start ${component} &>>${log_file}
  status_check $?
}

schema_load() {
    print_head "Creating mongodb repo"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    status_check $?

    print_head "Installing mongodb client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "loading ${component} schema"
    mongo --host mongodb.mydevopslearning.online </app/schema/${component}.js &>>${log_file}
    status_check $?
}