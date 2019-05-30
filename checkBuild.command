#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""

set -o pipefail && xcodebuild -workspace "Example/LogsManager.xcworkspace" -scheme "LogsManager-Example" -configuration "Release"  -sdk iphonesimulator | xcpretty

echo

xcodebuild -project "CarthageSupport/LogsManager.xcodeproj" -alltargets  -sdk iphonesimulator | xcpretty

echo ""
echo "SUCCESS!"
echo ""
