SHELL                   := $(shell which bash) -o pipefail
ABS_TOP                 := $(subst /cygdrive/c/,C:/, $(shell pwd))
VIVADO                  ?= vivado
VIVADO_OPTS             ?= -nolog -nojournal -mode batch
FPGA_PART               ?= xc7z020clg400-3
RTL                     += $(subst /cygdrive/c/,C:/, $(shell find $(ABS_TOP)/src -type f -name "*.v"))
CONSTRAINTS             += $(subst /cygdrive/c/,C:/, $(shell find $(ABS_TOP)/src -type f -name "*.xdc"))
TOP                     ?= z1top
VCS                     := vcs -full64
VCS_OPTS                := -notice -PP -line +lint=all,noVCDE +v2k -timescale=1ns/10ps -debug
SIM_RTL                 := $(subst /cygdrive/c/,C:/, $(shell find $(ABS_TOP)/sim -type f -name "*.v"))
IVERILOG                := iverilog
IVERILOG_OPTS           := -D IVERILOG=1
VVP                     := vvp

sim/%.tb: sim/%.v $(RTL)
	cd sim && $(VCS) $(VCS_OPTS) -o $*.tb $(RTL) $*.v -top $*

sim/%.vpd: sim/%.tb
	cd sim && ./$*.tb +verbose=1 +vpdfile+$*.vpd

sim/%.tbi: sim/%.v $(RTL)
	cd sim && $(IVERILOG) $(IVERILOG_OPTS) -o $*.tbi $*.v $(RTL)

sim/%.vcd: sim/%.tbi
	cd sim && $(VVP) $*.tbi

build/target.tcl: $(RTL) $(CONSTRAINTS)
	mkdir -p build
	echo "set ABS_TOP                        $(ABS_TOP)"    >> $@
	echo "set TOP                            $(TOP)"    >> $@
	echo "set FPGA_PART                      $(FPGA_PART)"  >> $@
	echo "set_param general.maxThreads       4"    >> $@
	echo "set_param general.maxBackupLogs    0"    >> $@
	echo -n "set RTL { " >> $@
	FLIST="$(RTL)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	echo "}" >> $@
	echo -n "set CONSTRAINTS { " >> $@
	FLIST="$(CONSTRAINTS)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	echo "}" >> $@

setup: build/target.tcl

build/synth/$(TOP).dcp: build/target.tcl $(ABS_TOP)/scripts/synth.tcl
	mkdir -p ./build/synth/
	cd ./build/synth/ && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/synth.tcl |& tee synth.log

synth: build/synth/$(TOP).dcp

build/impl/$(TOP).bit: build/synth/$(TOP).dcp $(ABS_TOP)/scripts/impl.tcl
	mkdir -p ./build/impl/
	cd ./build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/impl.tcl |& tee impl.log

impl: build/impl/$(TOP).bit
all: build/impl/$(TOP).bit

program: build/impl/$(TOP).bit $(ABS_TOP)/scripts/program.tcl
	cd build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/program.tcl

vivado: build
	cd build && nohup $(VIVADO) </dev/null >/dev/null 2>&1 &

lint:
	verilator --lint-only --top-module $(TOP) $(RTL)

sim_build/compile_simlib/synopsys_sim.setup:
	mkdir -p sim_build/compile_simlib
	cd build/sim_build/compile_simlib && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/scripts/compile_simlib.tcl

compile_simlib: sim_build/compile_simlib/synopsys_sim.setup

clean:
	rm -rf ./build $(junk) *.daidir output.txt
	rm -rf sim/*.tb sim/*.daidir sim/csrc
	rm -rf sim/ucli.key sim/*.vpd sim/*.vcd

.PHONY: setup synth impl program vivado all clean %.tb
