#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /home/fourniem/Playground/GVE/Hardware/plug-fpga/src/random/hash/murmur3/HLS/murmur3.prj/solution1/.autopilot/db/a.g.bc ${1+"$@"}
