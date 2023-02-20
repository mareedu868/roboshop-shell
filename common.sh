code_dir=$(pwd)
log_file=/tmp/roboshop.log
err_file=/tmp/roboerr.log
rm -rf ${log_file}

print_head() {
  echo -e "\e[34m$1\e[0m"
}