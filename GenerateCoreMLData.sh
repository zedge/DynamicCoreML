#!/bin/bash

COREMLC=$(xcode-select -p)/usr/bin/coremlc

[ ! -f $COREMLC ] && echo "Failed to locate coremlc program, is xcode-select set up correctly?" && exit 1

[ ! -f "$1" ] && echo "No input file specified" && exit 1

$COREMLC compile "$1" "$PWD"
