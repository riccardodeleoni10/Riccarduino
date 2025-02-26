library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gpio is
    port (
        clk,reset: in std_logic;  
        dir      : in std_logic;  
        gpio_w : in std_logic; 
        gpio_r  : out std_logic; 
        gpio_pin : inout std_logic  
    );
end entity;

architecture Behavioral of gpio is

begin
   
gpio_pin_process:process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then gpio_pin<='0';
        elsif dir = '1' then
            gpio_pin <= gpio_w; 
        else
            gpio_pin <= 'Z';
            gpio_r <= gpio_pin; 
        end if;
    end if;
end process;

end Behavioral;
