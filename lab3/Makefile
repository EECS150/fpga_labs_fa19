ABS_TOP          := $(shell pwd)
BUILD_SUFFIX     := $(shell date +%Y-%m-%d_%H-%M)
VIVADO           ?= /opt/Xilinx/Vivado/2019.1/bin/vivado
VIVADO_OPTS      ?= -nolog -nojournal -mode batch
FPGA_PART        ?= xc7z020clg400-3
RTL              += $(shell find $(ABS_TOP)/src -type f -name "*.v")
CONSTRAINTS      += $(shell find $(ABS_TOP)/src -type f -name "*.xdc")
TOP              ?= z1top

build:
	@mkdir -p build

build/target.tcl: $(RTL) $(CONSTRAINTS) build
	@echo "set ABS_TOP                        $(ABS_TOP)"    >> $@
	@echo "set TOP                            $(TOP)"    >> $@
	@echo "set FPGA_PART                      $(FPGA_PART)"  >> $@
	@echo "set_param general.maxThreads       4"    >> $@
	@echo "set_param general.maxBackupLogs    0"    >> $@
	@echo -n "set RTL { " >> $@
	@FLIST="$(RTL)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	@echo "}" >> $@
	@echo -n "set CONSTRAINTS { " >> $@
	@FLIST="$(CONSTRAINTS)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	@echo "}" >> $@

setup: build/target.tcl

build/synth/latest/$(TOP).dcp: build/target.tcl $(ABS_TOP)/scripts/synth.tcl
	mkdir -p ./build/synth/$(BUILD_SUFFIX)
	ln -sfn $(BUILD_SUFFIX) ./build/synth/working
	cd ./build/synth/$(BUILD_SUFFIX) && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/synth.tcl | tee synth.log
	ln -sfn $(BUILD_SUFFIX) ./build/synth/latest

synth: build/synth/latest/$(TOP).dcp

build/impl/latest/$(TOP).bit: build/synth/latest/$(TOP).dcp $(ABS_TOP)/scripts/impl.tcl
	mkdir -p ./build/impl/$(BUILD_SUFFIX)
	ln -sfn $(BUILD_SUFFIX) ./build/impl/working
	cd ./build/impl/$(BUILD_SUFFIX) && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/impl.tcl | tee impl.log
	ln -sfn $(BUILD_SUFFIX) ./build/impl/latest

impl: build/impl/latest/$(TOP).bit
all: build/impl/latest/$(TOP).bit

program: build/impl/latest/$(TOP).bit $(ABS_TOP)/scripts/program.tcl
	cd build/impl/latest && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/program.tcl

vivado: build
	cd build && nohup $(VIVADO) </dev/null >/dev/null 2>&1 &

sim_build/compile_simlib/synopsys_sim.setup:
	mkdir -p sim_build/compile_simlib
	cd build/sim_build/compile_simlib && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/compile_simlib.tcl

compile_simlib: sim_build/compile_simlib/synopsys_sim.setup

clean:
	rm -rf ./build

.PHONY: setup synth impl program vivado all clean
