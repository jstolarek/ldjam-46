#!/bin/bash

git submodule init
git submodule update

haxelib newrepo
haxelib git heaps heaps/
haxelib git deepnightLibs deepnightLibs/
haxelib git castle castle/
haxelib git heapsOgmo heapsOgmo/

haxelib install hlsdl
haxelib install hashlink  # needed for native builds
