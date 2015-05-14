
These scripts were tested with Perl 5.16 on Mac OS X 10.10.  Should run on Windows too but YMMV.  

To install copy _thesis.pl_ and _bookslist.pm_ to your folder where you have _thesis.txt_.  Clicking on this 
file should cause the *perl* interpreter to run and generate the related HTML and RSS files.

On a traditional Unix host you can test the code with 

```
    perl bookslist-test.pl
```

You should see output looking something like

```
    someuser@somemachine.edu$ perl bookslist-test.pl
    Testing BooksList.pm
    Success!
```

If you don't see the "Success!" line then something went wrong. Sorry.


