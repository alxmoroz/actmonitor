#!/usr/bin/env bash

# Copyright (c) 2022. Alexandr Moroz

echo "build_runner build..."

flutter pub run build_runner build --delete-conflicting-outputs

echo "build_runner build complete"
