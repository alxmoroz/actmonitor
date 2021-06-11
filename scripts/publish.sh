#!/usr/bin/env bash

# Copyright (c) 2021. Alexandr Moroz

flutter clean

bash ./scripts/build_runner_clean.sh
bash ./scripts/build_runner_build.sh
bash ./scripts/test.sh || exit
bash ./scripts/bump_version.sh
#bash ./scripts/build_android.sh
bash ./scripts/build_ios.sh
#bash ./scripts/build_web.sh
#bash ./deploy.sh
