#!/bin/bash

# Builds a native Linux version
mkdir -p bin/stroll
haxe hl.c.sdl.hxml > /dev/null && \
clang -O3 -o bin/stroll -std=c17 -I bin/stroll bin/stroll/main.c /usr/lib/*.hdll -lhl -lSDL2 -lopenal -lm -lGL

