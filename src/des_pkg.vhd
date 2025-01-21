library IEEE;
use IEEE.STD_LOGIC_1164.all;

package des_pkg is
    -- DES block size constants
    constant BLOCK_SIZE : integer := 64;
    constant KEY_SIZE   : integer := 56;
    constant ROUND_NUM  : integer := 16;
    
    -- Types for DES operations
    type block_array is array (0 to ROUND_NUM) of std_logic_vector(BLOCK_SIZE-1 downto 0);
    type key_array is array (0 to ROUND_NUM-1) of std_logic_vector(47 downto 0);
    
    -- Initial Permutation Table
    type ip_table_type is array (0 to 63) of integer range 1 to 64;
    constant IP_TABLE : ip_table_type := (
        58, 50, 42, 34, 26, 18, 10, 2,
        60, 52, 44, 36, 28, 20, 12, 4,
        62, 54, 46, 38, 30, 22, 14, 6,
        64, 56, 48, 40, 32, 24, 16, 8,
        57, 49, 41, 33, 25, 17, 9, 1,
        59, 51, 43, 35, 27, 19, 11, 3,
        61, 53, 45, 37, 29, 21, 13, 5,
        63, 55, 47, 39, 31, 23, 15, 7
    );

    -- Final Permutation Table
    constant FP_TABLE : ip_table_type := (
        40, 8, 48, 16, 56, 24, 64, 32,
        39, 7, 47, 15, 55, 23, 63, 31,
        38, 6, 46, 14, 54, 22, 62, 30,
        37, 5, 45, 13, 53, 21, 61, 29,
        36, 4, 44, 12, 52, 20, 60, 28,
        35, 3, 43, 11, 51, 19, 59, 27,
        34, 2, 42, 10, 50, 18, 58, 26,
        33, 1, 41, 9, 49, 17, 57, 25
    );

    -- E-bit Selection Table
    type e_table_type is array (0 to 47) of integer range 1 to 32;
    constant E_TABLE : e_table_type := (
        32, 1, 2, 3, 4, 5,
        4, 5, 6, 7, 8, 9,
        8, 9, 10, 11, 12, 13,
        12, 13, 14, 15, 16, 17,
        16, 17, 18, 19, 20, 21,
        20, 21, 22, 23, 24, 25,
        24, 25, 26, 27, 28, 29,
        28, 29, 30, 31, 32, 1
    );

    -- Component declarations
    component initial_permutation is
        port (
            data_in  : in  std_logic_vector(63 downto 0);
            data_out : out std_logic_vector(63 downto 0)
        );
    end component;

    component final_permutation is
        port (
            data_in  : in  std_logic_vector(63 downto 0);
            data_out : out std_logic_vector(63 downto 0)
        );
    end component;

    component round is
        port (
            data_in  : in  std_logic_vector(63 downto 0);
            key      : in  std_logic_vector(47 downto 0);
            data_out : out std_logic_vector(63 downto 0)
        );
    end component;

    component key_schedule is
        port (
            key     : in  std_logic_vector(63 downto 0);
            encrypt : in  std_logic;
            round_keys : out key_array
        );
    end component;

end package des_pkg;