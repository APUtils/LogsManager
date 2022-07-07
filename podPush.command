#!/bin/bash

base_dir=$(dirname "$0")
cd "$base_dir"

set -e

# Pushing latest version to cocoapods
pod trunk push RoutableLogger.podspec
pod trunk push LogsManager.podspec
