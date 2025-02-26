----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2025 13:29:23
-- Design Name: 
-- Module Name: instr_mem_dec - Behavioral
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
use ieee.numeric_std .all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_mem_dec is
      generic (
        N_BIT : integer := 13
      );
      Port ( 
        instr_addr_in: in std_logic_vector (N_BIT -1 downto 0);
        instr_addr_out: out std_logic_vector (N_BIT-1 downto 0)
      );
end instr_mem_dec;

architecture Behavioral of instr_mem_dec is

begin
decoding: process (instr_addr_in)
variable to_shift : unsigned (N_BIT -1 downto 0);
variable shifter : integer;
begin
    to_shift := unsigned (instr_addr_in);
    shifter := 2;
    instr_addr_out <= std_logic_vector(shift_right(to_shift,shifter));
end process;

end Behavioral;
