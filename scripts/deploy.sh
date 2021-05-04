#!/usr/bin/env bash

if ! [ "$APP_SYNC_PATH" ]; then
  echo "Путь APP_SYNC_PATH до папки деплоя не определен в env"
  exit 1
fi

echo "DEPLOYING..."

appName="Choice"

version="v$(grep 'version: ' ./pubspec.yaml | sed 's/version: //')"

# Android
deployPathAndroid="${APP_SYNC_PATH}/builds/$version/Android"
if ! [ -d "$deployPathAndroid" ]; then
  mkdir -p "$deployPathAndroid"
fi

#mv "./build/app/outputs/flutter-apk/app-release.apk" "${deployPathAndroid}/${appName}_all_platforms_${version}.apk"
mv "./build/app/outputs/bundle/release/app-release.aab" "${deployPathAndroid}/${appName}_bundle_${version}.aab"

# iOS
#deployPath_iOS="${APP_SYNC_PATH}/builds/$version/iOS"
#if ! [ -d "$deployPath_iOS" ]; then
#  mkdir -p "$deployPath_iOS"
#fi

#mv "./build/ios/OwnNative.xcarchive" "${deployPath_iOS}/${appName}_${version}.xcarchive"

echo "DEPLOYING COMPLETE"
