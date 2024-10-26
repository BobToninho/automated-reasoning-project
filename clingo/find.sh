#!/bin/bash

# usage: ./find.sh aliens_file.lp <min> <max> <time_limit>
#        ./find.sh aliens6.lp 60 70 150

trap 'echo "Script interrupted"; exit 1' SIGINT SIGTERM

data_file=${1:-aliens0.lp}
min_tries=${2:-1}
max_tries=${3:-20}
time_limit=${4:-300}

echo -e "Running $data_file with t from $min_tries to $max_tries with time limit $time_limit"

for i in $(seq $min_tries $max_tries);
do
  echo "Trying $i"
  clingo --time-limit=$time_limit -c t=$i invaders.lp $data_file 1 > /dev/null
  exit_code=$?

  case $exit_code in
    10 | 30)
      echo $i
      exit 0
  esac
done

echo "No solution found"
