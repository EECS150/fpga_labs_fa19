CASES := $(wildcard tests/*.do)
#CASES := $(wildcard tests/echo.do)
TESTINPUTS := $(wildcard tests/*.input)
TRANSCRIPT := $(patsubst tests/%.do,results/%.transcript,$(CASES))
DOFILES := $(patsubst tests/%.do,build/%.do,$(CASES))
TESTINPUTSBUILD := $(patsubst tests/%.input,build/%.input,$(TESTINPUTS))
SRCDIR := ../*.srcs/
SRCS := $(shell find $(SRCDIR) -name '*.v' -type f)
INC := $(shell find $(SRCDIR) -type d -exec echo -n '+incdir+../'{} \;)
STATUS := build/.status
###XILINX_LIBS := unisims_ver unimacro_ver xilinxcorelib_ver secureip
XILINX_LIBS := unisims_ver unimacro_ver secureip
XILINX_LIB_INC := $(foreach lib,$(XILINX_LIBS),$(addprefix -L ,$(lib)))
###XILINX_LIBS_MAP := $(wildcard /opt/Xilinx/Vivado/current/compile_simlib/modelsim/10.6b/*)
XILINX_LIBS_INI := /opt/Xilinx/Vivado/current/compile_simlib/modelsim/10.6b/modelsim.ini

# Compute VDEFINES based on passed-in argument, SIMDEFS
null      :=
SPACE     := $(null) $(null)
VDEFINES  := +define+$(subst $(SPACE),+,$(SIMDEFS))

all: $(TRANSCRIPT)

compile: $(STATUS)

$(STATUS): $(SRCS) | build/Makefile
	make -C build
	touch $@

build/Makefile:
	mkdir -p build
	cp $(XILINX_LIBS_INI) ./build/
	(cd build; vlib -type directory work; vmap work work)
	(cd build; \
	vlog +acc -vopt -O5 -source -nocovercells \
	/opt/Xilinx/Vivado/current/data/verilog/src/glbl.v \
	|| exit 1)
	(cd build; \
	vlog +acc -vmake -vopt -source -O5 -nocovercells $(VDEFINES) $(INC) $(foreach src,$(SRCS),$(addprefix ../,$(src))) || exit 1)
	(cd build; vmake work > Makefile)

results:
	mkdir -p results

$(DOFILES) : build/%.do : tests/%.do
	mkdir -p build
	echo 'proc start {m} {vsim $(XILINX_LIB_INC) $$m work.glbl}' \
	| cat - $< > $@ 

### echo 'proc start {m} {vsim $(XILINX_LIB_INC) -lib xil_defaultlib  work.glbl $$m}' \

$(TESTINPUTSBUILD) : build/% : tests/%
	cp $< $@
	
$(TRANSCRIPT) : results/%.transcript : build/%.do $(STATUS) $(TESTINPUTSBUILD) | results
	(cd build; \
	vsim < ../$< | tee ../$@)
	# cp build/vsim.wlf $(patsubst %.transcript,%.wlf,$@)
	mv build/vsim.wlf $(patsubst %.transcript,%.wlf,$@)

clean:
	rm -rf results build

.PHONY := all clean compile
