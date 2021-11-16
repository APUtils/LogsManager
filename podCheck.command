#!/bin/bash

base_dir=$(dirname "$0")
cd "$base_dir"

# Checking lib lint
pod lib lint --no-clean
