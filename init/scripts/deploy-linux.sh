#!/bin/bash

if [ -z "$TEST_DIR" ]
then
    echo "TEST_DIR was not set, please enter the path: "
    read input_variable
    export TEST_DIR=$input_variable
fi
