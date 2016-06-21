

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "sprite_engine" "NUM_INSTANCES" "DEVICE_ID"  "C_S_TEST_AXI_BASEADDR" "C_S_TEST_AXI_HIGHADDR"
}
