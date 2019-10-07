# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "OPEN_ADDRESS_WIDTH"
  ipgui::add_param $IPINST -name "CLOSED_ADDRESS_WIDTH"

}

proc update_PARAM_VALUE.CLOSED_ADDRESS_WIDTH { PARAM_VALUE.CLOSED_ADDRESS_WIDTH } {
	# Procedure called to update CLOSED_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOSED_ADDRESS_WIDTH { PARAM_VALUE.CLOSED_ADDRESS_WIDTH } {
	# Procedure called to validate CLOSED_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.OPEN_ADDRESS_WIDTH { PARAM_VALUE.OPEN_ADDRESS_WIDTH } {
	# Procedure called to update OPEN_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OPEN_ADDRESS_WIDTH { PARAM_VALUE.OPEN_ADDRESS_WIDTH } {
	# Procedure called to validate OPEN_ADDRESS_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.OPEN_ADDRESS_WIDTH { MODELPARAM_VALUE.OPEN_ADDRESS_WIDTH PARAM_VALUE.OPEN_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OPEN_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.OPEN_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.CLOSED_ADDRESS_WIDTH { MODELPARAM_VALUE.CLOSED_ADDRESS_WIDTH PARAM_VALUE.CLOSED_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOSED_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.CLOSED_ADDRESS_WIDTH}
}

