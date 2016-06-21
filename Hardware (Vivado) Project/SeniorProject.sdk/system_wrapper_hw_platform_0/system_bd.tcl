
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set IIC_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0 ]
  set btns [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 btns ]
  set leds [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 leds ]
  set switches [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 switches ]

  # Create ports
  set Ethernet125Mhz [ create_bd_port -dir I -type clk Ethernet125Mhz ]
  set_property -dict [ list \
CONFIG.CLK_DOMAIN {system_processing_system7_0_0_FCLK_CLK0} \
CONFIG.FREQ_HZ {125000000} \
 ] $Ethernet125Mhz
  set blue [ create_bd_port -dir O -from 4 -to 0 blue ]
  set data [ create_bd_port -dir I data ]
  set green [ create_bd_port -dir O -from 5 -to 0 green ]
  set h_sync [ create_bd_port -dir O h_sync ]
  set latch [ create_bd_port -dir O latch ]
  set pulse [ create_bd_port -dir O pulse ]
  set red [ create_bd_port -dir O -from 4 -to 0 red ]
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl
  set v_sync [ create_bd_port -dir O v_sync ]

  # Create instance: NesController_0, and set properties
  set NesController_0 [ create_bd_cell -type ip -vlnv user.org:user:NesController:1.0 NesController_0 ]

  # Create instance: btns_gpio, and set properties
  set btns_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 btns_gpio ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_GPIO_WIDTH {3} \
 ] $btns_gpio

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {80.0} \
CONFIG.CLKOUT1_JITTER {112.754} \
CONFIG.CLKOUT1_PHASE_ERROR {86.070} \
CONFIG.CLKOUT2_JITTER {148.894} \
CONFIG.CLKOUT2_PHASE_ERROR {86.070} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25.175} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.MMCM_CLKFBOUT_MULT_F {9.500} \
CONFIG.MMCM_CLKIN1_PERIOD {8.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {11.875} \
CONFIG.MMCM_CLKOUT1_DIVIDE {47} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {2} \
CONFIG.RESET_PORT {reset} \
CONFIG.RESET_TYPE {ACTIVE_HIGH} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: ground, and set properties
  set ground [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ground ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $ground

  # Create instance: leds_gpio, and set properties
  set leds_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 leds_gpio ]
  set_property -dict [ list \
CONFIG.C_ALL_OUTPUTS {1} \
CONFIG.C_GPIO_WIDTH {4} \
 ] $leds_gpio

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_EN_CLK0_PORT {0} \
CONFIG.PCW_EN_RST0_PORT {0} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_IMPORT_BOARD_PRESET {/mnt/Data/XilinxProjects/ZYBO_zynq_def.xml} \
CONFIG.PCW_MIO_16_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {fast} \
CONFIG.PCW_MIO_17_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {fast} \
CONFIG.PCW_MIO_18_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {fast} \
CONFIG.PCW_MIO_19_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {fast} \
CONFIG.PCW_MIO_20_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {fast} \
CONFIG.PCW_MIO_21_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {fast} \
CONFIG.PCW_MIO_22_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {fast} \
CONFIG.PCW_MIO_23_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {fast} \
CONFIG.PCW_MIO_24_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {fast} \
CONFIG.PCW_MIO_25_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {fast} \
CONFIG.PCW_MIO_26_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {fast} \
CONFIG.PCW_MIO_27_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {fast} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {fast} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {fast} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {fast} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {fast} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {fast} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {fast} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {fast} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {fast} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {fast} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {fast} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {fast} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {fast} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {fast} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {fast} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {fast} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {fast} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {fast} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {fast} \
CONFIG.PCW_MIO_47_PULLUP {enabled} \
CONFIG.PCW_MIO_52_PULLUP {disabled} \
CONFIG.PCW_MIO_53_PULLUP {disabled} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {32} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP2 {1} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {5} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: sprite_engine_0, and set properties
  set sprite_engine_0 [ create_bd_cell -type ip -vlnv devonandrade.com:user:sprite_engine:1.0.3 sprite_engine_0 ]
  set_property -dict [ list \
CONFIG.C_M_FRAMEREAD_AXI_BURST_LEN {16} \
CONFIG.C_S00_AXI_ADDR_WIDTH {16} \
CONFIG.MAX_SPRITES {256} \
 ] $sprite_engine_0

  # Create instance: switches_gpio, and set properties
  set switches_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 switches_gpio ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_GPIO_WIDTH {4} \
 ] $switches_gpio

  # Create interface connections
  connect_bd_intf_net -intf_net btns_gpio_GPIO [get_bd_intf_ports btns] [get_bd_intf_pins btns_gpio/GPIO]
  connect_bd_intf_net -intf_net leds_gpio_GPIO [get_bd_intf_ports leds] [get_bd_intf_pins leds_gpio/GPIO]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins processing_system7_0/IIC_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins leds_gpio/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins btns_gpio/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI] [get_bd_intf_pins switches_gpio/S_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI] [get_bd_intf_pins sprite_engine_0/S_CMD_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins NesController_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net sprite_engine_0_M_DMA_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP2] [get_bd_intf_pins sprite_engine_0/M_DMA_AXI]
  connect_bd_intf_net -intf_net sprite_engine_0_M_FRAMEREAD_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins sprite_engine_0/M_FRAMEREAD_AXI]
  connect_bd_intf_net -intf_net switches_gpio_GPIO [get_bd_intf_ports switches] [get_bd_intf_pins switches_gpio/GPIO]

  # Create port connections
  connect_bd_net -net NesController_0_latch [get_bd_ports latch] [get_bd_pins NesController_0/latch]
  connect_bd_net -net NesController_0_pulse [get_bd_ports pulse] [get_bd_pins NesController_0/pulse]
  connect_bd_net -net blank_n [get_bd_pins sprite_engine_0/blank_n]
  connect_bd_net -net clk_in1_1 [get_bd_ports Ethernet125Mhz] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins NesController_0/s00_axi_aclk] [get_bd_pins btns_gpio/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins leds_gpio/s_axi_aclk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins sprite_engine_0/m_dma_axi_aclk] [get_bd_pins sprite_engine_0/m_frameread_axi_aclk] [get_bd_pins sprite_engine_0/s00_axi_aclk] [get_bd_pins switches_gpio/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins sprite_engine_0/pixel_clk]
  connect_bd_net -net data_1 [get_bd_ports data] [get_bd_pins NesController_0/data]
  connect_bd_net -net ground_dout [get_bd_pins ground/dout] [get_bd_pins processing_system7_0/SDIO0_WP]
  connect_bd_net -net reset_rtl_1 [get_bd_ports reset_rtl] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins NesController_0/s00_axi_aresetn] [get_bd_pins btns_gpio/s_axi_aresetn] [get_bd_pins leds_gpio/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn] [get_bd_pins sprite_engine_0/m_dma_axi_aresetn] [get_bd_pins sprite_engine_0/m_frameread_axi_aresetn] [get_bd_pins sprite_engine_0/s00_axi_aresetn] [get_bd_pins switches_gpio/s_axi_aresetn]
  connect_bd_net -net sprite_engine_0_blue [get_bd_ports blue] [get_bd_pins sprite_engine_0/blue]
  connect_bd_net -net sprite_engine_0_green [get_bd_ports green] [get_bd_pins sprite_engine_0/green]
  connect_bd_net -net sprite_engine_0_h_sync [get_bd_ports h_sync] [get_bd_pins sprite_engine_0/h_sync]
  connect_bd_net -net sprite_engine_0_red [get_bd_ports red] [get_bd_pins sprite_engine_0/red]
  connect_bd_net -net sprite_engine_0_v_sync [get_bd_ports v_sync] [get_bd_pins sprite_engine_0/v_sync]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NesController_0/S00_AXI/S00_AXI_reg] SEG_NesController_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs btns_gpio/S_AXI/Reg] SEG_btns_gpio_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs leds_gpio/S_AXI/Reg] SEG_leds_gpio_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs sprite_engine_0/S_TEST_AXI/S_TEST_AXI_reg] SEG_sprite_engine_0_S_TEST_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x41220000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs switches_gpio/S_AXI/Reg] SEG_switches_gpio_Reg
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces sprite_engine_0/M_FRAMEREAD_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces sprite_engine_0/M_DMA_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port switches -pg 1 -y 760 -defaultsOSRD
preplace port DDR -pg 1 -y 50 -defaultsOSRD
preplace port Ethernet125Mhz -pg 1 -y 420 -defaultsOSRD
preplace port h_sync -pg 1 -y 510 -defaultsOSRD
preplace port btns -pg 1 -y 380 -defaultsOSRD
preplace port reset_rtl -pg 1 -y 510 -defaultsOSRD
preplace port pulse -pg 1 -y 910 -defaultsOSRD
preplace port latch -pg 1 -y 890 -defaultsOSRD
preplace port v_sync -pg 1 -y 530 -defaultsOSRD
preplace port IIC_0 -pg 1 -y 90 -defaultsOSRD
preplace port leds -pg 1 -y 630 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 70 -defaultsOSRD
preplace port data -pg 1 -y 890 -defaultsOSRD
preplace portBus blue -pg 1 -y 490 -defaultsOSRD
preplace portBus green -pg 1 -y 470 -defaultsOSRD
preplace portBus red -pg 1 -y 450 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 2 -y 530 -defaultsOSRD
preplace inst switches_gpio -pg 1 -lvl 5 -y 760 -defaultsOSRD
preplace inst NesController_0 -pg 1 -lvl 5 -y 900 -defaultsOSRD
preplace inst leds_gpio -pg 1 -lvl 5 -y 630 -defaultsOSRD
preplace inst btns_gpio -pg 1 -lvl 5 -y 380 -defaultsOSRD
preplace inst sprite_engine_0 -pg 1 -lvl 4 -y 480 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -y 420 -defaultsOSRD
preplace inst ground -pg 1 -lvl 5 -y 260 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 3 -y 650 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -y 110 -defaultsOSRD
preplace netloc switches_gpio_GPIO 1 5 1 NJ
preplace netloc btns_gpio_GPIO 1 5 1 NJ
preplace netloc processing_system7_0_DDR 1 5 1 NJ
preplace netloc NesController_0_pulse 1 5 1 NJ
preplace netloc sprite_engine_0_v_sync 1 4 2 NJ 530 NJ
preplace netloc sprite_engine_0_green 1 4 2 NJ 470 NJ
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 3 1 860
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 3 2 N 610 NJ
preplace netloc processing_system7_0_M_AXI_GP0 1 2 4 540 310 NJ 310 NJ 310 1660
preplace netloc clk_in1_1 1 0 1 NJ
preplace netloc processing_system7_0_IIC_0 1 5 1 NJ
preplace netloc NesController_0_latch 1 5 1 NJ
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 3 2 850 740 NJ
preplace netloc sprite_engine_0_M_DMA_AXI 1 4 1 1240
preplace netloc sprite_engine_0_h_sync 1 4 2 NJ 510 NJ
preplace netloc sprite_engine_0_red 1 4 2 NJ 450 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 2 3 520 450 850 600 1260
preplace netloc sprite_engine_0_blue 1 4 2 NJ 490 NJ
preplace netloc processing_system7_0_FIXED_IO 1 5 1 NJ
preplace netloc sprite_engine_0_M_FRAMEREAD_AXI 1 4 1 1230
preplace netloc data_1 1 0 5 NJ 890 NJ 890 NJ 890 NJ 890 NJ
preplace netloc clk_wiz_0_clk_out1 1 1 4 180 420 530 440 870 360 1250
preplace netloc leds_gpio_GPIO 1 5 1 NJ
preplace netloc ground_dout 1 5 1 1670
preplace netloc clk_wiz_0_clk_out2 1 1 3 NJ 430 NJ 430 N
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 2 1 N
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 3 2 840 870 NJ
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 3 2 840 350 NJ
preplace netloc blank_n 1 4 1 N
preplace netloc reset_rtl_1 1 0 2 NJ 510 NJ
levelinfo -pg 1 0 100 350 690 1050 1460 1690 -top 0 -bot 980
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


