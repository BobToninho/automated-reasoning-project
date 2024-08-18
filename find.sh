for i in {1..100}
do
  clingo -c t=$i invaders5.lp 1
  exit_code=$?

  case $exit_code in
    10 | 30)
      echo "t=$i"
      exit 0
  esac
done
