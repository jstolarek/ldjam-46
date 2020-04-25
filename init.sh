#!/bin/bash

git submodule init
git submodule update

haxelib newrepo

# Heaps dependency
haxelib install format
haxelib install hashlink  # needed for native C builds
haxelib install hlsdl

# upstream versions of libraries
haxelib dev heaps heaps/
haxelib dev deepnightLibs deepnightLibs/
haxelib dev castle castle/
haxelib dev heapsOgmo heapsOgmo/
