test=true
# test=false

if [ $test = true ]; then
clingo \
  -c a=4 \
  -c t=4 \
  -c x=4 \
  -c y=10 \
  invaders4.lp 1
else
clingo \
  -c a=4 \
  -c t=4 \
  -c x=4 \
  -c y=10 \
  invaders4.lp 1 --text | rg \
    moveX
fi
