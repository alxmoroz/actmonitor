#!/usr/bin/env bash

build_number=$(git rev-list --all | wc -l | xargs)
sed -i.bak "s/^\(version:.*[.]\).*$/\1$build_number+$build_number/" pubspec.yaml

version=$(grep 'version: ' pubspec.yaml | sed 's/version: //')

git commit -m "Bump version to $version" pubspec.yaml
git tag "$version"
git push

echo "Bump version to $version to git"
