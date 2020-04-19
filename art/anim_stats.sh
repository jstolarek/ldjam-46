#!/bin/bash

# Shows anims in atlas, and frame count
# Usage:
# sh anim_stats.sh atlas_name.atlas

cat "$@" | tail -n +7 | grep -v '^  ' | uniq -c
