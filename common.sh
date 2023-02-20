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