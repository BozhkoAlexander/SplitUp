#!/bin/sh

#  release.sh
#  
#
#  Created by Alexander Bozhko on 11/01/2019.
#  

echo Release $1...

pod lib lint &&

git add -A;
git commit -m "release $1" &&
git push &&
git tag $1 &&
git push --tags &&

pod repo push kinoapp-ios-podspec Splitup.podspec
