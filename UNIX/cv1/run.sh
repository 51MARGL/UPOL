cat -n test1.txt | head -n 20 | tail -n 11
cat -n test1.txt | head -n 20 | tail -n 11 | tac

echo ""
sort -k 3 -r -n test2.txt 

echo ""
paste <(cut -f 2 test2.txt)  <(cut -f 1 test2.txt) <(cut -f 3- test2.txt)

echo ""
grep -v -f diff1.txt diff2.txt 

