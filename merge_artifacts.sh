#!/bin/bash

artifacts_dir='artifacts'
merged_artifacts_dir='merged_artifacts'

mkdir -p $merged_artifacts_dir

cp -r $artifacts_dir/linux-x86_64 $merged_artifacts_dir/
cp -r $artifacts_dir/windows-x86_64 $merged_artifacts_dir/
cp -r $artifacts_dir/macos-arm64 $merged_artifacts_dir/