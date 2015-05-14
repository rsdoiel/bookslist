
test: 
	perl bookslist-test.pl

perltidy: test
	perltidy-5.16 -b booklist.pm
	perltidy-5.16 -b booklist-test.pl
	perltidy-5.16 -b thesis.pl

run: test
	if [ ! -f ./thesis.txt ]; then echo "Missing thesis.txt"; exit 1; fi
	perl thesis.pl

clean:
	/bin/rm *.htm
	/bin/rm *.xml
	/bin/rm *.bak

