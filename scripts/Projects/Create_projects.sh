
export PROJ_DIR=/home/fourniem/Playground/GVE/Hardware/Projects
export SDK_WS_DIR=/home/fourniem/Playground/GVE/Hardware/SDK_WS
source ~/.bash_aliases

for open in stack
do 
    for closed in  hashtable
    do 
    export OPEN_TYPE=$open
    export CLOSED_TYPE=$closed
    export PROJ_NAME=GVE_${OPEN_TYPE}_${CLOSED_TYPE}
    export HWDEF_DIR=/home/fourniem/Playground/GVE/Hardware/HDF/${OPEN_TYPE}_${CLOSED_TYPE}
    export BSP_NAME=GVE_${OPEN_TYPE}_${CLOSED_TYPE}_BSP
    export HW_PRJ_NAME=GVE_${OPEN_TYPE}_${CLOSED_TYPE}_HW
    export SDK_WS_NAME=GVE_${OPEN_TYPE}_${CLOSED_TYPE}_SDK
    # vivado -mode batch -source ./GVE_DFS_bf.tcl
    /tools/Xilinx/SDK/2018.3/bin/xsdk -batch -source GVE_gen_BSP.tcl
    done 
done 

