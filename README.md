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

-   Data declerations
-   implement typeclasses
-   Finish typing rules

Edwards OH:

-   SYNTAX!!!
-   Type-checking concerns (typeclasses, multiplicities, etc. (No inference???))
-   Pipeline organization (Should we do our plan of parsing and then buildling
    multiple different lambdas that get set to different places)
-   Modified do notation ??? (he already said no, but we can still ask)
-   Implementation details (typeclasses, lambda calculus, algebraic data types (tagged unions??))
-   Mention to him more specifically our memory design and see what he say (garbage collection)
