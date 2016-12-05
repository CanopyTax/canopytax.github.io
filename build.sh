#!/bin/bash -e

echo "Building..."
cd src
hugo
cp -r public/* ../
