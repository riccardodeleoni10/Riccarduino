----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2025 21:51:06
-- Design Name: 
-- Module Name: load_result_unit - Behavioral
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

entity load_result_unit is
      generic (
        N_BIT: integer := 32
      );
      Port ( 
        din : in std_logic_vector (N_BIT-1 downto 0);
        LRUctrl: in std_logic_vector (2 downto 0);
        dout: out std_logic_vector (N_BIT -1 downto 0)
      );
end load_result_unit;

architecture Behavioral of load_result_unit is

begin
load_type: process(din,LRUctrl)
begin
    case LRUctrl is 
        when "010" => dout <= din; --lw;
        when "100" => dout <= din and x"000000ff"; -- load byte unsigned
        when "101" => dout <= din and x"0000ffff"; -- load half unsigned
        when "000" => dout <= ((N_BIT -1 downto 8 => din(7)) & din(7 downto 0)); --load byte (con segno);
        when "001" => dout <= ((N_BIT-1 downto 16 => din (15)) & din (15 downto 0));-- load hlaf con segno
        when others => dout <= din; -- condizione don't care a caso
    end case;   
end process;


end Behavioral;
