#!/bin/bash

GAME=stroll

echo -n "Cleaning previous builds..."
rm -rf dist/$GAME-js dist/$GAME-linux-x86_64
rm -f dist/$GAME-js.zip dist/$GAME-linux-x86_64.tar.gz dist/$GAME-win64.zip dist/$GAME-win64/hlboot.dat
echo "done"

# Build HTML5
echo -n "Building HTML5 release..."
haxe js.hxml > /dev/null
if [[ -f "bin/$GAME.js" ]]; then
    mkdir -p dist/$GAME-js/bin
    cp index.html dist/$GAME-js
    cp bin/$GAME.js dist/$GAME-js/bin
    cd dist/$GAME-js/
    zip $GAME-js.zip index.html bin/$GAME.js > /dev/null
    mv $GAME-js.zip ..
    cd - > /dev/null
    echo "done"
else
    echo "compilation error!"
fi

# Build native Linux
echo -n "Building Linux release..."
mkdir -p bin/"$GAME"_src
haxe hl.c.sdl.hxml > /dev/null && \
clang -O3 -o bin/$GAME -std=c17 -I bin/"$GAME"_src bin/"$GAME"_src/main.c /usr/lib/*.hdll -lhl -lSDL2 -lopenal -lm -lGL
if [[ -f "bin/$GAME" ]]; then
    mkdir -p dist/$GAME-linux-x86_64
    cp bin/$GAME dist/$GAME-linux-x86_64
    cd dist
    tar zcf $GAME-linux-x86_64.tar.gz $GAME-linux-x86_64
    cd - > /dev/null
    echo "done"
else
    echo "compilation error!"
fi


# Build Windows bytecode
echo -n "Building Windows release..."
haxe hl.sdl.hxml > /dev/null
if [[ -f "bin/$GAME.hl" ]]; then
    mkdir -p dist/$GAME-win64
    cp bin/$GAME.hl dist/$GAME-win64/hlboot.dat
    cd dist
    zip $GAME-win64.zip $GAME-win64/* > /dev/null
    cd - > /dev/null
    echo "done"
else
    echo "compilation error!"
fi
