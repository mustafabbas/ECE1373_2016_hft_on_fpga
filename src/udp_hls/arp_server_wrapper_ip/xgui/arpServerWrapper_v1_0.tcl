# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "keyLength" -parent ${Page_0}
  ipgui::add_param $IPINST -name "valueLength" -parent ${Page_0}


}

proc update_PARAM_VALUE.keyLength { PARAM_VALUE.keyLength } {
	# Procedure called to update keyLength when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.keyLength { PARAM_VALUE.keyLength } {
	# Procedure called to validate keyLength
	return true
}

proc update_PARAM_VALUE.valueLength { PARAM_VALUE.valueLength } {
	# Procedure called to update valueLength when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.valueLength { PARAM_VALUE.valueLength } {
	# Procedure called to validate valueLength
	return true
}


proc update_MODELPARAM_VALUE.keyLength { MODELPARAM_VALUE.keyLength PARAM_VALUE.keyLength } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.keyLength}] ${MODELPARAM_VALUE.keyLength}
}

proc update_MODELPARAM_VALUE.valueLength { MODELPARAM_VALUE.valueLength PARAM_VALUE.valueLength } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.valueLength}] ${MODELPARAM_VALUE.valueLength}
}

