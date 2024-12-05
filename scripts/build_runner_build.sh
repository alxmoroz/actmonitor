#!/usr/bin/env bash

# Copyright (c) 2024. Alexandr Moroz

echo "build_runner build..."

dart run build_runner build --delete-conflicting-outputs

echo "build_runner build complete"
