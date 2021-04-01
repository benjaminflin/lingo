#!/bin/sh 

#1) find all .lingo files in the reg-test directory 
#for each one, run convert on it (to "compile" and get the output)
#this generates a (filename).a.out file. Compare this against the (filename).out file (w expected output)
#if they are the same, test passes
#if they are different, write output to .diff file

#build command, this works on my system bc it's weirdly configured
#For Ben/Jay probably just run "dune build" 
~/.opam/default/bin/dune build

globallog=../testall.log
rm -f ./testall.log

error=0
keep=0
globalerror=0

PREFIX="./reg-tests/"
ACTUAL=".a.out"
EXPECTED=".out"

SignalError() {
    if [ $error -eq 0 ] ; then
        echo "FAILED"
        error=1
    fi
    echo "  $1"
}

# runs the test file, saves output to <filename>.a.out
Run() {
  cd ../
  echo "dune exec ./reg-tests/convert.exe $1" >> "testall.log"
  dune exec ./reg-tests/convert.exe $1 
}

# Does dif between <filename>.a.out and <filename>.out 
# If they are same, test passes. 
# Else, diff written to file and test fails.
Compare () {
  echo "diff $PREFIX$1$ACTUAL $PREFIX$1$EXPECTED" >> "testall.log"
  diff -b $PREFIX$1$ACTUAL $PREFIX$1$EXPECTED > "reg-tests/$1.diff" || {
      SignalError "$1 differs"
      echo "FAILED $1 ACTUAL differs from EXPECTED" 
  }
}

# Delete generated files
Clean () {
  rm *.a.out *.s
}

CheckFail() {
  if [ $error -eq 0 ] ; then
    if [ $keep -eq 0 ] ; then
      rm -f $PREFIX$1.a.out $PREFIX$1.lingo.s $PREFIX$1 $PREFIX$1.diff
    fi
    echo "OK"
    echo "###### SUCCESS" >> "testall.log" 
  else
    echo "###### FAILED" >> "testall.log"
    globalerror=$error
  fi
}

#finds all .lingo files in test dir. 
#runs them, compares their output against the expectation.
cd ./reg-tests/
for i in *.lingo; do
    echo "###### Testing $i " >> $globallog 
    basename=${i%%.*} #this is the file name without the .lingo part
    Run $basename
    Compare $basename
    CheckFail $basename
    cd ./reg-tests/      
done