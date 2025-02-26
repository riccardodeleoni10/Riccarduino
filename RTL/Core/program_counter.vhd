----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.01.2025 19:46:02
-- Design Name: 
-- Module Name: program_counter - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
    generic (
        N_BIT: integer := 13
    );
     Port ( 
        clk,reset,PCsrc : in std_logic;
        pc_branch : in  std_logic_vector (N_BIT -1 downto 0);
        pc_t: out std_logic_vector(N_BIT-1 downto 0)
        );
end program_counter;

architecture Behavioral of program_counter is
signal pc_next,pc_reg : std_logic_vector (N_BIT-1 downto 0);
begin
input_mux: process(PCsrc,pc_next,pc_branch)
begin 
    if PCsrc =  '0' then 
        pc_reg <= pc_next+4;
    else pc_reg <= pc_branch;
    end if;
end process;
pc_process: process(clk)
begin 
    if rising_edge (clk) then 
        if reset = '1' then pc_next <= (others => '0');
        else pc_next <= pc_reg ;
        end if;
    end if;
end process;
pc_t <= pc_next;
end Behavioral;
