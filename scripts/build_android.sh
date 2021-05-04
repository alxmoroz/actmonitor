#!/usr/bin/env bash

echo "BUILDING FOR ANDROID..."

#flutter build apk --release
flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --release

echo "BUILDING FOR ANDROID COMPLETE"
