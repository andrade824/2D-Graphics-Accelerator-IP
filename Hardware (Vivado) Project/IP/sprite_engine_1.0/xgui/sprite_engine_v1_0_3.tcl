# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Group
  set AXI_Parameters [ipgui::add_group $IPINST -name "AXI Parameters"]
  ipgui::add_param $IPINST -name "C_M_FRAMEREAD_AXI_BURST_LEN" -parent ${AXI_Parameters} -widget comboBox
  ipgui::add_param $IPINST -name "C_M_AXI_DMA_MAX_BURST_LEN" -parent ${AXI_Parameters}
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${AXI_Parameters}

  #Adding Group
  set Horizontal_Timing [ipgui::add_group $IPINST -name "Horizontal Timing"]
  ipgui::add_param $IPINST -name "H_VISIBLE" -parent ${Horizontal_Timing}
  ipgui::add_param $IPINST -name "H_FRONT_PORCH" -parent ${Horizontal_Timing}
  ipgui::add_param $IPINST -name "H_SYNC" -parent ${Horizontal_Timing}
  ipgui::add_param $IPINST -name "H_BACK_PORCH" -parent ${Horizontal_Timing}

  #Adding Group
  set Vertical_Timing [ipgui::add_group $IPINST -name "Vertical Timing"]
  ipgui::add_param $IPINST -name "V_VISIBLE" -parent ${Vertical_Timing}
  ipgui::add_param $IPINST -name "V_FRONT_PORCH" -parent ${Vertical_Timing}
  ipgui::add_param $IPINST -name "V_SYNC" -parent ${Vertical_Timing}
  ipgui::add_param $IPINST -name "V_BACK_PORCH" -parent ${Vertical_Timing}

  #Adding Group
  set Sprite_Controller [ipgui::add_group $IPINST -name "Sprite Controller"]
  ipgui::add_param $IPINST -name "MAX_SPRITES" -parent ${Sprite_Controller}


}

proc update_PARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH { PARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH } {
	# Procedure called to update C_M_AXI_DMA_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH { PARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH } {
	# Procedure called to validate C_M_AXI_DMA_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH { PARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH } {
	# Procedure called to update C_M_AXI_DMA_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH { PARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH } {
	# Procedure called to validate C_M_AXI_DMA_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN { PARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN } {
	# Procedure called to update C_M_AXI_DMA_MAX_BURST_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN { PARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN } {
	# Procedure called to validate C_M_AXI_DMA_MAX_BURST_LEN
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.H_BACK_PORCH { PARAM_VALUE.H_BACK_PORCH } {
	# Procedure called to update H_BACK_PORCH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_BACK_PORCH { PARAM_VALUE.H_BACK_PORCH } {
	# Procedure called to validate H_BACK_PORCH
	return true
}

proc update_PARAM_VALUE.H_FRONT_PORCH { PARAM_VALUE.H_FRONT_PORCH } {
	# Procedure called to update H_FRONT_PORCH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_FRONT_PORCH { PARAM_VALUE.H_FRONT_PORCH } {
	# Procedure called to validate H_FRONT_PORCH
	return true
}

proc update_PARAM_VALUE.H_SYNC { PARAM_VALUE.H_SYNC } {
	# Procedure called to update H_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_SYNC { PARAM_VALUE.H_SYNC } {
	# Procedure called to validate H_SYNC
	return true
}

proc update_PARAM_VALUE.H_VISIBLE { PARAM_VALUE.H_VISIBLE } {
	# Procedure called to update H_VISIBLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_VISIBLE { PARAM_VALUE.H_VISIBLE } {
	# Procedure called to validate H_VISIBLE
	return true
}

proc update_PARAM_VALUE.MAX_SPRITES { PARAM_VALUE.MAX_SPRITES } {
	# Procedure called to update MAX_SPRITES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_SPRITES { PARAM_VALUE.MAX_SPRITES } {
	# Procedure called to validate MAX_SPRITES
	return true
}

proc update_PARAM_VALUE.V_BACK_PORCH { PARAM_VALUE.V_BACK_PORCH } {
	# Procedure called to update V_BACK_PORCH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_BACK_PORCH { PARAM_VALUE.V_BACK_PORCH } {
	# Procedure called to validate V_BACK_PORCH
	return true
}

proc update_PARAM_VALUE.V_FRONT_PORCH { PARAM_VALUE.V_FRONT_PORCH } {
	# Procedure called to update V_FRONT_PORCH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_FRONT_PORCH { PARAM_VALUE.V_FRONT_PORCH } {
	# Procedure called to validate V_FRONT_PORCH
	return true
}

proc update_PARAM_VALUE.V_SYNC { PARAM_VALUE.V_SYNC } {
	# Procedure called to update V_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_SYNC { PARAM_VALUE.V_SYNC } {
	# Procedure called to validate V_SYNC
	return true
}

proc update_PARAM_VALUE.V_VISIBLE { PARAM_VALUE.V_VISIBLE } {
	# Procedure called to update V_VISIBLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_VISIBLE { PARAM_VALUE.V_VISIBLE } {
	# Procedure called to validate V_VISIBLE
	return true
}

proc update_PARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN { PARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN } {
	# Procedure called to update C_M_FRAMEREAD_AXI_BURST_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN { PARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN } {
	# Procedure called to validate C_M_FRAMEREAD_AXI_BURST_LEN
	return true
}

proc update_PARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH { PARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH } {
	# Procedure called to update C_M_FRAMEREAD_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH { PARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_M_FRAMEREAD_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH { PARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH } {
	# Procedure called to update C_M_FRAMEREAD_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH { PARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH } {
	# Procedure called to validate C_M_FRAMEREAD_AXI_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN { MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN PARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN}] ${MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_BURST_LEN}
}

proc update_MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH PARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH PARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_FRAMEREAD_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.H_VISIBLE { MODELPARAM_VALUE.H_VISIBLE PARAM_VALUE.H_VISIBLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_VISIBLE}] ${MODELPARAM_VALUE.H_VISIBLE}
}

proc update_MODELPARAM_VALUE.H_FRONT_PORCH { MODELPARAM_VALUE.H_FRONT_PORCH PARAM_VALUE.H_FRONT_PORCH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_FRONT_PORCH}] ${MODELPARAM_VALUE.H_FRONT_PORCH}
}

proc update_MODELPARAM_VALUE.H_SYNC { MODELPARAM_VALUE.H_SYNC PARAM_VALUE.H_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_SYNC}] ${MODELPARAM_VALUE.H_SYNC}
}

proc update_MODELPARAM_VALUE.H_BACK_PORCH { MODELPARAM_VALUE.H_BACK_PORCH PARAM_VALUE.H_BACK_PORCH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_BACK_PORCH}] ${MODELPARAM_VALUE.H_BACK_PORCH}
}

proc update_MODELPARAM_VALUE.V_VISIBLE { MODELPARAM_VALUE.V_VISIBLE PARAM_VALUE.V_VISIBLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_VISIBLE}] ${MODELPARAM_VALUE.V_VISIBLE}
}

proc update_MODELPARAM_VALUE.V_FRONT_PORCH { MODELPARAM_VALUE.V_FRONT_PORCH PARAM_VALUE.V_FRONT_PORCH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_FRONT_PORCH}] ${MODELPARAM_VALUE.V_FRONT_PORCH}
}

proc update_MODELPARAM_VALUE.V_SYNC { MODELPARAM_VALUE.V_SYNC PARAM_VALUE.V_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_SYNC}] ${MODELPARAM_VALUE.V_SYNC}
}

proc update_MODELPARAM_VALUE.V_BACK_PORCH { MODELPARAM_VALUE.V_BACK_PORCH PARAM_VALUE.V_BACK_PORCH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_BACK_PORCH}] ${MODELPARAM_VALUE.V_BACK_PORCH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN { MODELPARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN PARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN}] ${MODELPARAM_VALUE.C_M_AXI_DMA_MAX_BURST_LEN}
}

proc update_MODELPARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH PARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_DMA_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH PARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_DMA_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.MAX_SPRITES { MODELPARAM_VALUE.MAX_SPRITES PARAM_VALUE.MAX_SPRITES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_SPRITES}] ${MODELPARAM_VALUE.MAX_SPRITES}
}

