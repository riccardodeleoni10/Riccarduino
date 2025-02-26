----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2025 22:42:18
-- Design Name: 
-- Module Name: addresse_decoding - Behavioral
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

entity addresse_decoding is
      generic (
        dm_location: integer :=9;
        timer_location: integer:= 2
      )
      ;
      Port ( 
        mem_write: in std_logic;
        addr_in: in std_logic_vector (31 downto 0);
        write_vector: out std_logic_vector (1 downto 0);
        addr_out: out std_logic_vector (31 downto 0)
        );
end addresse_decoding;

architecture Behavioral of addresse_decoding is
signal addresse_decoded: std_logic_vector (31 downto 0);
begin
addresse_decoding_logic: process(addr_in,mem_write)
begin
    if TO_INTEGER(unsigned(addr_in)) <= dm_location then 
        addresse_decoded<= addr_in;
    elsif dm_location < TO_INTEGER(unsigned(addr_in)) and TO_INTEGER(unsigned(addr_in)) <= (dm_location + timer_location) then 
          addresse_decoded <= addr_in - std_logic_vector(TO_UNSIGNED(dm_location,32)+1);
    else addresse_decoded <= (others => '0');
    end if;
    if mem_write = '1' then 
        if TO_INTEGER(unsigned(addr_in)) <= dm_location
            then write_vector <= "01";
        elsif  dm_location < TO_INTEGER(unsigned(addr_in)) and TO_INTEGER(unsigned(addr_in)) <= (dm_location + timer_location) then 
            write_vector <= "10";
        else write_vector<= "00";
        end if;
    else write_vector <= "00";
    end if;  
end process;
addr_out<=addresse_decoded;


end Behavioral;
