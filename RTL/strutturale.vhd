----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2025 17:18:32
-- Design Name: 
-- Module Name: strutturale - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity strutturale is
      Port ( 
        clk,reset: in std_logic;
        n : out std_logic
      );
end strutturale;

architecture Behavioral of strutturale is
component processore_top is  generic (
        INSTR_LENGTH: integer := 32
      );
      Port ( 
        clk,reset : in std_logic;
        Instr_mem_data: in std_logic_vector (INSTR_LENGTH -1 downto 0);
        Instr_mem_addr: out std_logic_vector (12 downto 0);
        N: out std_logic
      );
end component;
component design_1_wrapper is
  port (
     instr_addr_in_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    clka_0 : in STD_LOGIC;
    douta_0 : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end component design_1_wrapper;
signal instr2cpu: std_logic_vector (31 downto 0);
signal cpu2instr: std_logic_vector (12 downto 0);
begin
CPU: processore_top port map (
    clk => clk,
    reset => reset,
    instr_mem_data => instr2cpu,
    instr_mem_addr => cpu2instr,
    n => n
);
INSTR_MEM: design_1_wrapper port map (
     instr_addr_in_0 => cpu2instr,
    clka_0 => clk,
    douta_0 => instr2cpu
);

end Behavioral;
