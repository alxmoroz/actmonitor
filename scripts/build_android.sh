#!/usr/bin/env bash

# Copyright (c) 2024. Alexandr Moroz

echo "BUILDING FOR ANDROID..."

flutter build appbundle --release -t lib/L3_app/main.dart

echo "BUILDING FOR ANDROID COMPLETE"
