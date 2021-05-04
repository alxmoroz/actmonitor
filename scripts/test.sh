#!/usr/bin/env bash

flutter test --coverage

# отчет о покрытии
# genhtml coverage/lcov.info -o coverage/html > /dev/null
