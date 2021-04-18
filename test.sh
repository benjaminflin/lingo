#!/bin/bash
ARGS="$@"
docker-compose run lingo_testbed bash -c "python3 ./reg-tests/RunTests.py $ARGS"