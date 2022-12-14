# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 1
set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.cache/wt [current_project]
set_property parent.project_path C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/new/debouncer.sv
  C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/new/xvga.sv
  C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/new/top_level.sv
}
read_ip -quiet C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.xci
set_property used_in_implementation false [get_files -all c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/clk_wiz_65/clk_wiz_65_ooc.xdc]

read_ip -quiet C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xci
set_property used_in_implementation false [get_files -all c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_ooc.xdc]

read_ip -quiet C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/frame_blk_mem/frame_blk_mem.xci
set_property used_in_implementation false [get_files -all c:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/sources_1/ip/frame_blk_mem/frame_blk_mem_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/constrs_1/imports/Desktop/nexys4_ddr.xdc
set_property used_in_implementation false [get_files C:/Users/Nana/6111Projects/Ball_cols4/Ball_cols4.srcs/constrs_1/imports/Desktop/nexys4_ddr.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top top_level -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top_level.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_level_utilization_synth.rpt -pb top_level_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
