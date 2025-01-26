library ieee;

use ieee.std_logic_1164.all;

use work.all;

entity test_decryption is
end test_decryption;


architecture behavior of test_decryption is

	signal data_in: std_logic_vector(0 to 63);
	signal key: std_logic_vector(0 to 63);
	signal data_out: std_logic_vector(0 to 63);

begin

	uut:entity decrypt port map(data_in,key,data_out);
	testprocess: process is
	begin
		--data_in<="0000000100100011010001010110011110001001101010111100110111101111";
		data_in<="0011111110100100000011101000101010011000010011010100100000010101";
		key<="0000000100100011010001010110011110001001101010111100110111101111";
		wait for 10 ns;
		wait;
	end process testprocess;
end architecture behavior;
