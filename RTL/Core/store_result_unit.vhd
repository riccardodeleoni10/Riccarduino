----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.02.2025 11:36:17
-- Design Name: 
-- Module Name: store_result_unit - Behavioral
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

entity store_result_unit is
      Port ( 
        din: in std_logic_vector (31 downto 0);
        SRUctrl: in std_logic_vector (1 downto 0);
        dout: out std_logic_vector (31 downto 0)
      );
end store_result_unit;

architecture Behavioral of store_result_unit is

begin
store_type: process(din,SRUctrl)
begin
    case SRUctrl is 
        when "00" => dout <= din and x"000000ff"; --store byte
        when "01" => dout <= din and x"0000ffff"; -- store half
        when "10" => dout <= din; -- store word
        when others => dout <= (others => '0');
    end case;
end process;

end Behavioral;
