# GHDL commands
GHDL=~/tools/ghdl/bin/ghdl
GHDLFLAGS=--ieee=synopsys

# Project files
SOURCES = src/s1_box.vhd \
          src/s2_box.vhd \
          src/s3_box.vhd \
          src/s4_box.vhd \
          src/s5_box.vhd \
          src/s6_box.vhd \
          src/s7_box.vhd \
          src/s8_box.vhd \
          src/s_box.vhd \
          src/p_box.vhd \
          src/add_key.vhd \
          src/add_left.vhd \
          src/e_expansion_function.vhd \
          src/block_top.vhd \
          src/key_schedule.vhd \
          src/des_top.vhd \
          src/des_cipher_top.vhd

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
