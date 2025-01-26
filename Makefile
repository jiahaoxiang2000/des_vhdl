# GHDL commands
GHDL=~/tools/ghdl/bin/ghdl
GHDLFLAGS=--ieee=synopsys

# Project files
SOURCES = src/expand.vhdl \
          src/f.vhdl \
          src/initial_permutation.vhdl \
          src/key_permutation_1.vhdl \
          src/key_permutation_2.vhdl \
          src/left_shift_by_1.vhdl \
          src/left_shift_by_2.vhdl \
          src/permutation_p.vhdl \
          src/reverse_initial_permutation.vhdl \
          src/right_shift_by_1.vhdl \
          src/right_shift_by_2.vhdl \
          src/round.vhdl \
          src/s_box.vhdl \
          src/s1_box.vhdl \
          src/s2_box.vhdl \
          src/s3_box.vhdl \
          src/s4_box.vhdl \
          src/s5_box.vhdl \
          src/s6_box.vhdl \
          src/s7_box.vhdl \
          src/s8_box.vhdl \
          src/split_48_bits_to_8x6.vhdl \
          src/subkey_production.vhdl \
          src/swap_left_right_64_bits.vhdl \
          src/xor_32_bits.vhdl \
          src/xor_48_bits.vhdl \
          src/encrypt.vhdl \
          src/decrypt.vhdl

TESTBENCH = tb/test_encryption.vhdl \
            tb/test_decryption.vhdl
        

# Targets
all: compile simulate

compile:
	$(GHDL) -a $(GHDLFLAGS) $(SOURCES)
	$(GHDL) -a $(GHDLFLAGS) $(TESTBENCH)
	$(GHDL) -e $(GHDLFLAGS) test_encryption
	$(GHDL) -e $(GHDLFLAGS) test_decryption 

simulate:
	$(GHDL) -r $(GHDLFLAGS) test_encryption --vcd=test_encryption.vcd
	$(GHDL) -r $(GHDLFLAGS) test_decryption --vcd=test_decryption.vcd 

clean:
	rm -f *.o *.cf work-obj93.cf *.vcd
	rm -f test_encryption 

.PHONY: all compile simulate clean
