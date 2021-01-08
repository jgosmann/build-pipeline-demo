#!/bin/bash

./gradlew build
mkdir -p output
cp -R build output/
cp Dockerfile output/
