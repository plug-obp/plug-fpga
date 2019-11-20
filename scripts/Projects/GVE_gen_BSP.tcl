set open_type $::env(OPEN_TYPE)
set closed_type $::env(CLOSED_TYPE)
set project_name $::env(PROJ_NAME)
set project_directory $::env(PROJ_DIR)
set hwdef_directory $::env(HWDEF_DIR)

set hdf_name hdf_${open_type}_${closed_type}.hdf

set hw_proj_name ${project_name}_HW
set bsp_proj_name $::env(BSP_NAME)


set_workspace ${::env(SDK_WS_DIR)}/${::env(SDK_WS_NAME)}


if { [file exists "${hwdef_directory}/${hdf_name}"]} {
    if { [file exists "${hw_proj_name}"] == 0} {
        createhw -name ${hw_proj_name} -hwspec ${hwdef_directory}/${hdf_name}
    } else {
        puts "hw project already created"
        exit 
    }
}


createbsp -name ${bsp_proj_name} -hwproject $hw_proj_name -proc ps7_cortexa9_0 -os standalone

projects -build


