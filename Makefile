# GHDL commands
GHDL=ghdl
GHDLFLAGS=--ieee=synopsys

# Project files
SOURCES = src/des_pkg.vhd \
         src/des_entity.vhd \
         src/initial_permutation.vhd \
         src/final_permutation.vhd \
         src/round.vhd \
         src/key_schedule.vhd

TESTBENCH = tb/des_tb.vhd

# Targets
all: compile simulate

compile:
	$(GHDL) -a $(GHDLFLAGS) $(SOURCES)
	$(GHDL) -a $(GHDLFLAGS) $(TESTBENCH)
	$(GHDL) -e $(GHDLFLAGS) des_tb

simulate:
	$(GHDL) -r $(GHDLFLAGS) des_tb --vcd=wave.vcd

clean:
	rm -f *.o *.cf work-obj93.cf wave.vcd
	rm -f des_tb

.PHONY: all compile simulate clean
