#!/bin/bash
ARGS="$@"
# Run Python Tests
docker-compose run lingo_testbed bash -c "python3 ./reg-tests/RunTests.py $ARGS"
FAIL=$?
# Clean Up Stopped Docker Container
docker rm $(docker ps -a -q) > /dev/null 2>&1
if [[ $FAIL -eq 1 ]]
then 
    exit 1
fi