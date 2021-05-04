#!/usr/bin/env bash

echo "build_runner build..."

flutter pub run build_runner build --delete-conflicting-outputs

echo "build_runner build complete"
