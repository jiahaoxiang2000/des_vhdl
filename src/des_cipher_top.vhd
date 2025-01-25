library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity des_cipher_top is
port(
		--
		-- Core Interface 
		--
		key_in:				in std_logic_vector(0 to 63);		-- input for key
		--ldkey:				in std_logic;							-- signal for loading key
		function_select:	in	std_logic; 							-- function	select: '1' = encryption, '0' = decryption
		
		data_in:				in std_logic_vector(0 to 63);		-- input for data
		
		data_out:			out std_logic_vector(0 to 63);	-- output for data

		lddata:				in 	std_logic;						-- data strobe (active high)
		core_busy:			out	std_logic;						-- active high when encrypting/decryption data 
		des_out_rdy:		out	std_logic;						-- active high when encryption/decryption of data is done	

		reset: 				in std_logic;							-- active high
		clock: 				in std_logic							-- master clock

	);
end des_cipher_top;

architecture Behavioral of des_cipher_top is

--
-- 
--
component key_schedule is
port (
		-- Signals for loading key from external device
		key_in:			in std_logic_vector(0 to 63);		-- input for key
		
		-- signals for communication with des top
		KeySelect: 		in std_logic_vector(3 downto 0);	-- selector for key
    	key_out: 		out std_logic_vector(0 to 47);	-- expaned key (depends on selector)
		key_ready: 		out std_logic;							-- signal for the core that key has been expanded
	
		reset: in std_logic; 									-- active high
		clock: in std_logic  									-- master clock
		);
end component;

component des_top is
port (
		-- Main Data
		key_round_in:	in 	std_logic_vector(0 to 47);
		data_in:			in 	std_logic_vector(0 to 63);
		data_out:		out 	std_logic_vector(0 to 63);
		
		-- Signals for communication with des 
		KeySelect: 		inout std_logic_vector(3 downto 0);	-- selector for key
		key_ready: 		in std_logic;								-- signal for aes that key has been expanded
		data_ready: 	in std_logic;								-- signal for aes that key has been expanded
		func_select:	in std_logic;

		des_out_rdy: 	out std_logic;
		core_busy: 		out std_logic;	

		reset: 			in std_logic; 
		clock: 			in std_logic  								-- master clock
		);
end component;

signal key_select_internal: std_logic_vector(3 downto 0);
signal key_round_internal: std_logic_vector(0 to 47);
signal key_ready_internal: std_logic;
signal data_in_internal: std_logic_vector(0 to 63);
signal data_ready_internal: std_logic;

begin

process (clock)
begin
	
if rising_edge(clock) then
 
		if lddata = '1' then
		
			-- capute data from the bus
			data_in_internal 		<= data_in; -- register data from the bus
			data_ready_internal	<= '1';		-- data has been loaded: continue with encryptio/decryption   
		
		else
			
			data_ready_internal	<= '0';		-- data is not loaded: wait for data 
		
		end if;

end if;
end process;

--
-- KEY EXPANDER AND DES CORE instantiation
--
KEYSCHEDULE: key_schedule 
port map (

		KeySelect 	=> key_select_internal,
		key_in 		=> key_in,
		
		key_out 		=> key_round_internal,
		key_ready 	=> key_ready_internal,

		reset 		=> reset,
		clock 		=> clock
);

DESTOP: des_top 
port map (

		key_round_in 	=> key_round_internal,
		
		data_in		 	=> data_in_internal,
		
		key_ready 		=> key_ready_internal,
		data_ready 		=> data_ready_internal,

		KeySelect 		=> key_select_internal,

		func_select 	=> function_select,

		data_out 		=> data_out,
		core_busy 		=> core_busy,
		des_out_rdy 	=> des_out_rdy,

		reset 			=> reset,
		clock 			=> clock
);

end Behavioral;
