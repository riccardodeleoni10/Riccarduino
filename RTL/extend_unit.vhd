----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.01.2025 23:38:49
-- Design Name: 
-- Module Name: extend_unit - Behavioral
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

entity extend_unit is
      Port ( 
        instr : in std_logic_vector (24 downto 0);
        EXTctrl: in std_logic_vector (1 downto 0);
        EXTout: out std_logic_vector (31 downto 0)
      );
end extend_unit;

architecture Behavioral of extend_unit is

begin
extend_process: process(instr,EXTctrl)
begin
    case EXTctrl is 
        when "00" => EXTout<= (31 downto 12 => instr(24)) & instr(24 downto 13); 
        when "01" => EXTout <= (31 downto 12 => instr(24)) & instr (24 downto 18)& instr (4 downto 0);
        when "10" => EXTout <= (31 downto 12 => instr(24)) & instr(0) & instr (23 downto 18) & instr (4 downto 1)& '0';
        when others => EXTout <= (others => '-');
    end case;
end process;

end Behavioral;
