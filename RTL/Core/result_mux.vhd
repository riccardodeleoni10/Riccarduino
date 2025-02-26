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
            RESctrl: in std_logic;
            DMin: in std_logic_vector (31 downto 0);
            ALUin: in std_logic_vector (31 downto 0);
            Result: out std_logic_vector (31 downto 0)
      );
end result_mux;

architecture Behavioral of result_mux is

begin
mux: process(RESctrl,ALUin,DMin)
begin
    if RESctrl = '1' then Result <= ALUin;
        else 
            Result <= DMin;
    end if;
end process;

end Behavioral;
