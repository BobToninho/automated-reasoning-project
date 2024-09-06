trap 'echo "Script interrupted"; exit 1' SIGINT SIGTERM

data_file=${1:-aliens0.lp}
tries=${2:-20}

echo -e "Running $data_file for $tries times"

for i in $(seq 1 $tries);
do
  clingo -c t=$i invaders.lp $data_file 1 > /dev/null
  exit_code=$?

  case $exit_code in
    10 | 30)
      echo $i
      exit 0
  esac
done

echo "No solution found"
