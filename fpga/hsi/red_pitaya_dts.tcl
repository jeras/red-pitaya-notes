# instructions copied from:
# http://www.wiki.xilinx.com/Build+Device+Tree+Blob
open_hw_design sdk/red_pitaya.hwdef
set_repo_path ../../tmp/device-tree-xlnx-xilinx-v2014.4/
create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0
generate_target -dir dts
