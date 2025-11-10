#!/usr/bin/env bash

set -e
set -x

cd ./ios
pod update
pod install
cd ../