#!/bin/bash

trap 'echo "Script interrupted"; exit 1' SIGINT SIGTERM

data_file=${1:-aliens0.lp}
min_tries=${2:-1}
max_tries=${3:-20}

echo -e "Running $data_file with t from $min_tries to $max_tries"

for i in $(seq $min_tries $max_tries);
do
  echo "Trying $i"
  clingo --time-limit=300 -c t=$i invaders.lp $data_file 1 > /dev/null
  exit_code=$?

  case $exit_code in
    10 | 30)
      echo $i
      exit 0
  esac
done

echo "No solution found"
