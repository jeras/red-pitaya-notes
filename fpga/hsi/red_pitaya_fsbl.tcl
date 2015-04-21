# instructions copied from:
# http://www.wiki.xilinx.com/Build+FSBL
open_hw_design sdk/red_pitaya.sysdef
generate_app -hw system_imp -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir fsbl
