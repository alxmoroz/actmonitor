#!/usr/bin/env bash

build_number=$(git rev-list --all | wc -l | xargs)
sed -i.bak "s/^\(version:.*[.]\).*$/\1$build_number+$build_number/" pubspec.yaml

version=$(grep 'version: ' pubspec.yaml | sed "s/^[^0-9]*\(.*[.]\).*/\1$build_number/")

# extension
extPlistPath="ios/UsageWidgets/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_number" $extPlistPath
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $version" $extPlistPath

git commit -m "Bump version to $version" pubspec.yaml $extPlistPath
git tag "$version"
git push

echo "Bump version to $version to git"