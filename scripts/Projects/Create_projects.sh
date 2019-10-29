rm -rf /tmp/test/5/

export OPEN_TYPE=fifo
export CLOSED_TYPE=hashtable
export PROJ_NAME=test1
export PROJ_DIR=/tmp/test/6
export HWDEF_DIR=/home/fourniem/Playground/GVE/Hardware/HDF/${OPEN_TYPE}_${CLOSED_TYPE}

vivado -mode batch -source ./GVE_DFS_bf.tcl
