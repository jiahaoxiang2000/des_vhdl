-- filepath: /Users/xiangjiahao/embed/des_vhdl/src/des_pkg.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package des_pkg is
    -- DES block size constants
    constant BLOCK_SIZE : integer := 64;
    constant KEY_SIZE   : integer := 56;
    constant ROUND_NUM  : integer := 16;
    
    -- Types for DES operations
    type block_array is array (0 to ROUND_NUM) of std_logic_vector(BLOCK_SIZE-1 downto 0);
    type key_array is array (0 to ROUND_NUM-1) of std_logic_vector(KEY_SIZE-1 downto 0);
    
    -- Component declarations will be added here
end package des_pkg;