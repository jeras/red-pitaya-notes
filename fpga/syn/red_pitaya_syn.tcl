################################################################################
# Vivado tcl script for building RedPitaya FPGA in non project mode
#
# Usage:
# vivado -mode tcl -source red_pitaya_fpga.tcl
################################################################################

set part xc7z010clg400-1

create_project -in_memory -part $part

# experimental attempts to avoid a warning
#get_projects
#get_designs
#list_property  [current_project]
#set_property FAMILY 7SERIES [current_project]
#set_property SIM_DEVICE 7SERIES [current_project]

################################################################################
# define paths
################################################################################

set path_rtl ../rtl
set path_ip  ../ip
set path_sdc ../sdc

set path_out out
set path_sdk ../hsi/sdk

file mkdir $path_out
file mkdir $path_sdk

################################################################################
# read files:
# 1. RTL design sources
# 2. IP database files
# 3. constraints
################################################################################

# template
#read_verilog $path_rtl/...

read_bd      $path_ip/system.bd

read_verilog $path_ip/system_wrapper.v

read_verilog $path_rtl/axi_master.v
read_verilog $path_rtl/axi_slave.v
read_verilog $path_rtl/axi_wr_fifo.v

read_verilog $path_rtl/red_pitaya_acum.sv
read_verilog $path_rtl/red_pitaya_ams.v
read_verilog $path_rtl/red_pitaya_analog.v
read_verilog $path_rtl/red_pitaya_asg_ch.v
read_verilog $path_rtl/red_pitaya_asg.v
read_verilog $path_rtl/red_pitaya_daisy_rx.v
read_verilog $path_rtl/red_pitaya_daisy_test.v
read_verilog $path_rtl/red_pitaya_daisy_tx.v
read_verilog $path_rtl/red_pitaya_daisy.v
read_verilog $path_rtl/red_pitaya_dfilt1.v
read_verilog $path_rtl/red_pitaya_hk.v
read_verilog $path_rtl/red_pitaya_pid_block.v
read_verilog $path_rtl/red_pitaya_pid.v
read_verilog $path_rtl/red_pitaya_ps.v
read_verilog $path_rtl/red_pitaya_scope.v
read_verilog $path_rtl/red_pitaya_test.v
read_verilog $path_rtl/red_pitaya_top.v

read_xdc     $path_sdc/red_pitaya.xdc

################################################################################
# run synthesis
# report utilization and timing estimates
# write checkpoint design
################################################################################

# generate SDK files
generate_target all [get_files    $path_ip/system.bd]
write_hwdef              -file    $path_sdk/red_pitaya.hwdef

#synth_design -top red_pitaya_top
synth_design -top red_pitaya_top -flatten_hierarchy none -bufg 16 -keep_equivalent_registers

write_checkpoint         -force   $path_out/post_synth
report_timing_summary    -file    $path_out/post_synth_timing_summary.rpt
report_power             -file    $path_out/post_synth_power.rpt

################################################################################
# run placement and logic optimization
# report utilization and timing estimates
# write checkpoint design
################################################################################

opt_design
power_opt_design
place_design
phys_opt_design
write_checkpoint         -force   $path_out/post_place
report_timing_summary    -file    $path_out/post_place_timing_summary.rpt

################################################################################
# run router
# report actual utilization and timing,
# write checkpoint design
# run drc, write verilog and xdc out
################################################################################

route_design
write_checkpoint         -force   $path_out/post_route
report_timing_summary    -file    $path_out/post_route_timing_summary.rpt
report_timing            -file    $path_out/post_route_timing.rpt -sort_by group -max_paths 100 -path_type summary
report_clock_utilization -file    $path_out/clock_util.rpt
report_utilization       -file    $path_out/post_route_util.rpt
report_power             -file    $path_out/post_route_power.rpt
report_drc               -file    $path_out/post_imp_drc.rpt
#write_verilog            -force   $path_out/bft_impl_netlist.v
#write_xdc -no_fixed_only -force   $path_out/bft_impl.xdc

################################################################################
# generate a bitstream
################################################################################

write_bitstream -force $path_out/red_pitaya.bit

write_sysdef             -hwdef   $path_sdk/red_pitaya.hwdef \
                         -bitfile $path_out/red_pitaya.bit \
                         -file    $path_sdk/red_pitaya.sysdef

exit
