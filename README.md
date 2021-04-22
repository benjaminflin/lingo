# Container Commands

In order to run the docker container, make sure you are in the root directory of the Dockerfile
Current running on version 20.10.5, build 55c4c88

```
docker build --tag lingo .
```

Then in order to run the tests, run ./test.sh

If you want to alter the tests that are being run in the docker container you can edit the docker-compose.yml
and add different commands to the command section.

# Build Commands

```
dune build
dune exec ./tests/test_all.exe
```

TODO:
- Clean up code in general
- add stdlib to beginning of all files
