----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2025 15:56:21
-- Design Name: 
-- Module Name: pc_alu - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_alu is
      Port ( 
        pc : in std_logic_vector (12 downto 0);
        ext: in std_logic_vector (31 downto 0);
        pc_branch: out std_logic_vector (12 downto 0)
      );
end pc_alu;

architecture Behavioral of pc_alu is
signal pc_out : std_logic_vector (31 downto 0);
signal pc_31 : std_logic_vector (31 downto 0);
begin
pc_31 <= (31 downto 13 => pc (12)) & pc (12 downto 0); 
pc_compute: process(pc_31,ext)
variable pc_temp : std_logic_vector (31 downto  0);
begin
    pc_temp := (others => '0');
    pc_temp := pc_31 + ext;
    pc_out <= pc_temp - 4;
end process;
pc_branch<= pc_out (12 downto 0);
end Behavioral;
