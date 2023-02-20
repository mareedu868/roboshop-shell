code_dir=$(pwd)
log_file=/tmp/roboshop.log
err_file=/tmp/roboerr.log
rm -rf ${log_file}
rm -rf ${err_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
}