----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2025 22:05:28
-- Design Name: 
-- Module Name: counter - Behavioral
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

entity counter is
      Port ( 
        clk,reset : in std_logic;
        oc1,oc2: in std_logic_vector (15 downto 0);
        hit: out std_logic;
        pwm_out : out std_logic
      );
end counter;

architecture Behavioral of counter is
signal cnt: std_logic_vector (15 downto 0);
begin
contatore: process(clk,reset)
begin
    if rising_edge (clk) then 
        if reset = '0' then cnt  <= (others => '0');
        else
            cnt<=cnt+1;
        end if;
    end if;
end process;
interrupt_flag: process(cnt,oc1)
begin
    if cnt = oc1 then 
        hit <= '1';
    else hit <= '0';
    end if;
end process;
pwm_generator: process(clk,oc1,oc2,cnt)
begin 
    if rising_edge(clk) then 
        if cnt = oc1 then pwm_out<= '0';
        elsif cnt = oc2 then pwm_out <= '1';
        end if;
    end if;
end process;


end Behavioral;
