#!/bin/bash

git submodule init
git submodule update

haxelib newrepo
haxelib git heaps heaps/
haxelib git deepnightLibs deepnightLibs/
haxelib git castle castle/

haxelib install hlsdl
