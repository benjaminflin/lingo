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
- Close over let expressions and generate code for them 
    - Two separate cases for recursive/non-recursive
    - Note: dbindex 0 refers to self inside let expr
- Fix mono/box/unboxing because it's really buggy right now
- Produce lots of regression tests, and create a way to test them all at once __INSIDE DOCKER__
    - Hopefully, we can unify `tests/` and `reg-tests/`
- Produce implicit wildcard which calls `die()` for all case statements
- Fix substitution issue in typechecker 
- Clean up code in general
