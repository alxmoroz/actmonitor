#!/usr/bin/env bash

# Copyright (c) 2022. Alexandr Moroz

echo "BUILDING FOR ANDROID..."

#flutter build apk --release -t lib/L3_app/main.dart
flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --release -t lib/L3_app/main.dart

echo "BUILDING FOR ANDROID COMPLETE"
