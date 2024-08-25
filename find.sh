data_file=$1

for i in {1..30}
do
  echo -e "\nt=$i\n"
  clingo -c t=$i invaders.lp $data_file 1
  exit_code=$?

  case $exit_code in
    10 | 30)
      exit 0
  esac
done

echo "No solution found"
