----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.02.2025 15:57:52
-- Design Name: 
-- Module Name: result_mux - Behavioral
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


entity result_mux is
      Port ( 
            RESctrl: in std_logic_vector (1 downto 0);
            PCin: in std_logic_vector (12 downto 0);
            DMin: in std_logic_vector (31 downto 0);
            ALUin: in std_logic_vector (31 downto 0);
            Result: out std_logic_vector (31 downto 0)
      );
end result_mux;

architecture Behavioral of result_mux is

begin
mux: process(RESctrl,ALUin,DMin,PCin)
begin
    case RESctrl is 
        when "00" => Result <= DMin;
        when "01" => Result <= ALUin;
        when "10" => Result <= (31 downto 13 => '0') & PCin;
        When others => Result <= (others => '-');
    end case;
end process;

end Behavioral;
