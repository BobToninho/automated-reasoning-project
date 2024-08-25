for i in {1..30}
do
  echo -e "\nt=$i\n"
  clingo -c t=$i invaders5.lp 1
  exit_code=$?

  case $exit_code in
    10 | 30)
      exit 0
  esac
done

echo "No solution found"
