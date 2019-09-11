#=======================================================================
# UCB VLSI FLOW: Makefile for vcs-sim-rtl
#-----------------------------------------------------------------------
# Yunsup Lee (yunsup@cs.berkeley.edu)
#
# This makefile will build a rtl simulator and run various tests to
# verify proper functionality.
#

include ./Makefrag

default : all

basedir  = ./

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

# Library components


# Verilog sources

srcdir = $(basedir)/src
vsrcs = \
	$(srcdir)/fir.v \
	$(srcdir)/addertree.v \
	$(srcdir)/fir_tb.v \

vsrcs_gates = \
	$(srcdir)/fir.mapped.v \
	$(srcdir)/fir_tb.v \
	$(srcdir)/cells.v \



#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

VCS      = vcs -full64
VCS_OPTS = -notice -PP -line +lint=all,noVCDE +v2k -timescale=1ns/10ps -debug

#--------------------------------------------------------------------
# Build the simulator
#--------------------------------------------------------------------

vcs_sim = simv
$(vcs_sim) : Makefile $(vsrcs) 
	$(VCS) $(VCS_OPTS) +incdir+$(srcdir) -o $(vcs_sim) \
	       +define+CLOCK_PERIOD=$(vcs_clock_period) \
	       -sverilog $(vsrcs)

vcs_sim_gates = simv_gates
$(vcs_sim_gates) : Makefile $(vsrcs_gates) 
	$(VCS) $(VCS_OPTS) +incdir+$(srcdir) -o $(vcs_sim_gates) -P access.tab \
	       +define+CLOCK_PERIOD=$(vcs_clock_period) +notimingcheck +delay_mode_zero +no_notifier +evalorder +udpsched \
	       -sverilog $(vsrcs_gates)

vcs_sim_gates_hold = simv_gates_hold
$(vcs_sim_gates_hold) : Makefile $(vsrcs_gates) 
	$(VCS) $(VCS_OPTS) +incdir+$(srcdir) -o $(vcs_sim_gates_hold) -P access.tab \
	       +define+CLOCK_PERIOD=$(vcs_clock_period) +evalorder +udpsched \
	       +sdfverbose -sdf typ:fir:src/fir.mapped.hold.sdf \
	       -sverilog $(vsrcs_gates)

#--------------------------------------------------------------------
# Run
#--------------------------------------------------------------------

vpd = vcdplus.vpd
$(vpd): $(vcs_sim)
	./simv +verbose=1
	date > timestamp

vpd_gates = vcdplus_gates.vpd
$(vpd_gates): $(vcs_sim_gates)
	./simv_gates +verbose=1 -ucli -do run.tcl
	date > timestamp

vpd_gates_hold = vcdplus_gates_hold.vpd
$(vpd_gates_hold): $(vcs_sim_gates_hold)
	./simv_gates_hold +verbose=1 -ucli -do run.tcl
	date > timestamp

run: $(vpd)


run-gates: $(vpd_gates)

run-gates-hold: $(vpd_gates_hold)

#--------------------------------------------------------------------
# Default make target
#--------------------------------------------------------------------

.PHONY: run

all : $(vcs_sim)

#--------------------------------------------------------------------
# Clean up
#--------------------------------------------------------------------

junk += simv* csrc .vpd *.key DVE .vcs* timestamp

clean :
	rm -rf $(junk) ~ \# *.log *.cmd *.daidir