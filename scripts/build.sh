#!/usr/bin/env bash

set -e
set -x

flutter clean
flutter pub get

#bash ./scripts/build_api.sh

flutter pub global activate intl_utils
dart run intl_utils:generate

dart run build_runner build -d