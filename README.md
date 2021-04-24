# Container Commands

In order to run the docker container, make sure you are in the root directory of the Dockerfile
Current running on version 20.10.5, build 55c4c88

```
docker build --tag lingo:version2 .
```
# Running Tests

In order to run the tests, run ./test.sh. This script takes input an forwards them inside of the docker container to a python script. It has the following usage:
```
usage: test.sh [-h] [-c] [-s SRC_FILE] [-d SRC_DIR] [-o DIFF_DIR] [-ll LLVM_DIR] [-asm ASM_DIR] [-ex EXEC_DIR]
                   [-out OUT_DIR] [-lib LIB]

Runs regression tests for lingo files

optional arguments:
  -h, --help                        show this help message and exit
  -c, --clean                       cleans the reg-test directory
  -s SRC_FILE, --src-file SRC_FILE  specify a single src for testing
  -d SRC_DIR, --src-dir SRC_DIR     where to get source
  -o DIFF_DIR, --diff-dir DIFF_DIR  where to put diffs
  -ll LLVM_DIR, --llvm-dir LLVM_DIR where to put llvm
  -asm ASM_DIR, --asm-dir ASM_DIR   where to put asm
  -ex EXEC_DIR, --exec-dir EXEC_DIR where to put executable
  -out OUT_DIR, --out-dir OUT_DIR   where to output
  -lib LIB                          path to c library file
```

# Build Commands Inside Container
The following commands take a src and build llvm. From here everything can be compiled and linked with llc and gcc
```
dune build
dune exec ./src/lingo.exe [src]
dune clean
```

# Git Hooks
You must run the following command to initialize the testing git hooks.
`git config core.hooksPath .githooks`. This will run the testing script before every commit to make sure that there are no failing tests. 

TODO:
- Clean up code in general
- add stdlib to beginning of all files
