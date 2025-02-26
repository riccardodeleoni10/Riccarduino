----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.01.2025 22:50:23
-- Design Name: 
-- Module Name: register_file - Behavioral
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

entity register_file is
    generic (
            N_BIT: integer;
            N_REG: integer;
            ADDR_WIDHT: integer
    );
     Port ( 
        clk,reset: in std_logic;
        we3: in std_logic; -- write enable per la scrittura
        wd3: in std_logic_vector (N_BIT-1 downto 0);
        wa3: in std_logic_vector (ADDR_WIDHT-1 downto 0);
        ra2: in std_logic_vector (ADDR_WIDHT-1 downto 0);
        ra1: in std_logic_vector (ADDR_WIDHT-1 downto 0);
        rd1: out  std_logic_vector (N_BIT-1 downto 0);
        rd2: out  std_logic_vector (N_BIT-1 downto 0) 
     );
end register_file;

architecture Behavioral of register_file is
type reg_type is array (N_REG-1 downto 0) of std_logic_vector (N_BIT-1 downto 0);
signal reg_file : reg_type := (others => (others => '0'));

begin

write_read_process: process(clk) -- processo sincrono
begin
    if rising_edge (clk)  then
        if reset = '1' then 
           -- reg_file(1)<=x"0000000d";
            reg_file<= (others => (others=>'0'));
            rd1<= (others => '0');
            rd2<= (others => '0');
        else
            if we3 = '1' then
            reg_file(TO_INTEGER(unsigned(wa3)))<= wd3;
            end if;
        end if;
     end if;
     if (wd3 = ra1 and we3 = '1') then rd1<= wd3;
              else rd1<= reg_file(TO_INTEGER(unsigned(ra1)));
             end if;
             if (wd3 = ra2 and we3 = '1') then rd2<= wd3;
              else rd2<= reg_file(TO_INTEGER(unsigned(ra2)));
             end if;
end process;    

end Behavioral;
