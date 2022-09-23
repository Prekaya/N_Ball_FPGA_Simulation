vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic" \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../Balls_7.0.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65_clk_wiz.v" \
"../../../../Balls_7.0.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.v" \

vlog -work xil_defaultlib \
"glbl.v"

