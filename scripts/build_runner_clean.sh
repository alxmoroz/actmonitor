#!/usr/bin/env bash

echo "build_runner clean..."

flutter pub get
flutter pub run build_runner clean

echo "build_runner clean complete"
