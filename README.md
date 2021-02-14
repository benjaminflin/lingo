# Container Commands
In order to run the docker container, make sure you are in the root directory of the Dockerfile
```
docker build --tag plt .
docker run -it -v `pwd`:/home/lingo -w=/home/lingo plt
```
This should take a while to build, but it should allow better llvm support and building across platforms

# Build Commands

```
dune build
dune exec src/lingo.exe
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
