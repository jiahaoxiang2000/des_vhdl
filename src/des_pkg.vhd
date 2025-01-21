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

    -- PC1 Table type and constant
    type pc1_table_type is array (0 to 55) of integer range 1 to 64;
    constant PC1_TABLE : pc1_table_type := (
        57, 49, 41, 33, 25, 17, 9, 1,
        58, 50, 42, 34, 26, 18, 10, 2,
        59, 51, 43, 35, 27, 19, 11, 3,
        60, 52, 44, 36, 63, 55, 47, 39,
        31, 23, 15, 7, 62, 54, 46, 38,
        30, 22, 14, 6, 61, 53, 45, 37,
        29, 21, 13, 5, 28, 20, 12, 4
    );

    -- PC2 Table type and constant
    type pc2_table_type is array (0 to 47) of integer range 1 to 56;
    constant PC2_TABLE : pc2_table_type := (
        14, 17, 11, 24, 1, 5, 3, 28,
        15, 6, 21, 10, 23, 19, 12, 4,
        26, 8, 16, 7, 27, 20, 13, 2,
        41, 52, 31, 37, 47, 55, 30, 40,
        51, 45, 33, 48, 44, 49, 39, 56,
        34, 53, 46, 42, 50, 36, 29, 32
    );

    -- Key rotation schedule
    type rotation_table_type is array (0 to 15) of integer range 1 to 2;
    constant KEY_ROTATIONS : rotation_table_type := (
        1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1
    );

    -- S-box type definitions
    type sbox_array is array (0 to 63) of std_logic_vector(3 downto 0);
    type sbox_list is array (0 to 7) of sbox_array;
    
    -- S-box constants
    constant S_BOXES : sbox_list := (
        -- S1
        (X"E", X"4", X"D", X"1", X"2", X"F", X"B", X"8", 
         X"3", X"A", X"6", X"C", X"5", X"9", X"0", X"7",
         X"0", X"F", X"7", X"4", X"E", X"2", X"D", X"1",
         X"A", X"6", X"C", X"B", X"9", X"5", X"3", X"8",
         X"4", X"1", X"E", X"8", X"D", X"6", X"2", X"B",
         X"F", X"C", X"9", X"7", X"3", X"A", X"5", X"0",
         X"F", X"C", X"8", X"2", X"4", X"9", X"1", X"7",
         X"5", X"B", X"3", X"E", X"A", X"0", X"6", X"D"),
        -- S2
        (X"F", X"1", X"8", X"E", X"6", X"B", X"3", X"4",
         X"9", X"7", X"2", X"D", X"C", X"0", X"5", X"A",
         X"3", X"D", X"4", X"7", X"F", X"2", X"8", X"E",
         X"C", X"0", X"1", X"A", X"6", X"9", X"B", X"5",
         X"0", X"E", X"7", X"B", X"A", X"4", X"D", X"1",
         X"5", X"8", X"C", X"6", X"9", X"3", X"2", X"F",
         X"D", X"8", X"A", X"1", X"3", X"F", X"4", X"2",
         X"B", X"6", X"7", X"C", X"0", X"5", X"E", X"9"),
        -- S3
        (X"A", X"0", X"9", X"E", X"6", X"3", X"F", X"5",
         X"1", X"D", X"C", X"7", X"B", X"4", X"2", X"8",
         X"D", X"7", X"0", X"9", X"3", X"4", X"6", X"A",
         X"2", X"8", X"5", X"E", X"C", X"B", X"F", X"1",
         X"D", X"6", X"4", X"9", X"8", X"F", X"3", X"0",
         X"B", X"1", X"2", X"C", X"5", X"A", X"E", X"7",
         X"1", X"A", X"D", X"0", X"6", X"9", X"8", X"7",
         X"4", X"F", X"E", X"3", X"B", X"5", X"2", X"C"),
        -- S4
        (X"7", X"D", X"E", X"3", X"0", X"6", X"9", X"A",
         X"1", X"2", X"8", X"5", X"B", X"C", X"4", X"F",
         X"D", X"8", X"B", X"5", X"6", X"F", X"0", X"3",
         X"4", X"7", X"2", X"C", X"1", X"A", X"E", X"9",
         X"A", X"6", X"9", X"0", X"C", X"B", X"7", X"D",
         X"F", X"1", X"3", X"E", X"5", X"2", X"8", X"4",
         X"3", X"F", X"0", X"6", X"A", X"1", X"D", X"8",
         X"9", X"4", X"5", X"B", X"C", X"7", X"2", X"E"),
        -- S5
        (X"2", X"C", X"4", X"1", X"7", X"A", X"B", X"6",
         X"8", X"5", X"3", X"F", X"D", X"0", X"E", X"9",
         X"E", X"B", X"2", X"C", X"4", X"7", X"D", X"1",
         X"5", X"0", X"F", X"A", X"3", X"9", X"8", X"6",
         X"4", X"2", X"1", X"B", X"A", X"D", X"7", X"8",
         X"F", X"9", X"C", X"5", X"6", X"3", X"0", X"E",
         X"B", X"8", X"C", X"7", X"1", X"E", X"2", X"D",
         X"6", X"F", X"0", X"9", X"A", X"4", X"5", X"3"),
        -- S6
        (X"C", X"1", X"A", X"F", X"9", X"2", X"6", X"8",
         X"0", X"D", X"3", X"4", X"E", X"7", X"5", X"B",
         X"A", X"F", X"4", X"2", X"7", X"C", X"9", X"5",
         X"6", X"1", X"D", X"E", X"0", X"B", X"3", X"8",
         X"9", X"E", X"F", X"5", X"2", X"8", X"C", X"3",
         X"7", X"0", X"4", X"A", X"1", X"D", X"B", X"6",
         X"4", X"3", X"2", X"C", X"9", X"5", X"F", X"A",
         X"B", X"E", X"1", X"7", X"6", X"0", X"8", X"D"),
        -- S7
        (X"4", X"B", X"2", X"E", X"F", X"0", X"8", X"D",
         X"3", X"C", X"9", X"7", X"5", X"A", X"6", X"1",
         X"D", X"0", X"B", X"7", X"4", X"9", X"1", X"A",
         X"E", X"3", X"5", X"C", X"2", X"F", X"8", X"6",
         X"1", X"4", X"B", X"D", X"C", X"3", X"7", X"E",
         X"A", X"F", X"6", X"8", X"0", X"5", X"9", X"2",
         X"6", X"B", X"D", X"8", X"1", X"4", X"A", X"7",
         X"9", X"5", X"0", X"F", X"E", X"2", X"3", X"C"),
        -- S8
        (X"D", X"2", X"8", X"4", X"6", X"F", X"B", X"1",
         X"A", X"9", X"3", X"E", X"5", X"0", X"C", X"7",
         X"1", X"F", X"D", X"8", X"A", X"3", X"7", X"4",
         X"C", X"5", X"6", X"B", X"0", X"E", X"9", X"2",
         X"7", X"B", X"4", X"1", X"9", X"C", X"E", X"2",
         X"0", X"6", X"A", X"D", X"F", X"3", X"5", X"8",
         X"2", X"1", X"E", X"7", X"4", X"A", X"8", X"D",
         X"F", X"C", X"9", X"0", X"3", X"5", X"6", X"B")
    );

    -- P-box permutation table
    type p_table_type is array (0 to 31) of integer range 1 to 32;
    constant P_TABLE : p_table_type := (
        16, 7, 20, 21, 29, 12, 28, 17,
        1, 15, 23, 26, 5, 18, 31, 10,
        2, 8, 24, 14, 32, 27, 3, 9,
        19, 13, 30, 6, 22, 11, 4, 25
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