#
# $Id: Makefile 1026 2014-02-07 09:54:51Z matej.oblak $
#
# Red Pitaya Makefile for building ZYNQ PL and PS binary
#
# Produces:
#   1. FPGA bit file & XSDC configuration.
#   2. XSDK products.
#   3. Booting image & device-tree.
#

.PHONY: all clean image

# Cover task
all: syn fsbl dts
	echo ' \n'

#### CLEAN
clean:
	rm -rf syn/out syn/.Xil hsi/sdk
	rm -rf hsi/fsbl
	rm -rf hsi/dts
#	make -C image/ FPGA_TOOL=$(FPGA_TOOL) -k clean

#### Prepare images
#image: syn fsbl 
#	make -C image/ FPGA_TOOL=$(FPGA_TOOL) -k all

# create design tree
dts: hsi/dts/system.dts

hsi/dts/system.dts: syn
	cd hsi && hsi -mode batch -source red_pitaya_dts.tcl

# create First Stage Boot Loader executable
fsbl: hsi/fsbl/executable.elf

hsi/fsbl/executable.elf: syn
	cd hsi && hsi -mode batch -source red_pitaya_fsbl.tcl

# run Vivado (FPGA synthesis tool)
syn: syn/out/red_pitaya.bit

syn/out/red_pitaya.bit:
	cd syn && vivado -mode batch -source red_pitaya_syn.tcl
