----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2025 22:21:58
-- Design Name: 
-- Module Name: Timer - Structural
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

entity Timer is
      Port ( 
        addr : in std_logic_vector(31 downto 0);
        clk,reset,enable: in std_logic;
        din: in std_logic_vector(31 downto 0);
        int_flag,pwm_out : out std_logic
      );
end Timer;

architecture Structural of Timer is
component counter is
      Port ( 
        clk,reset : in std_logic;
        oc1,oc2: in std_logic_vector (15 downto 0);
        hit: out std_logic;
        pwm_out : out std_logic
      );
end component counter;
component prescaler is
    generic (
        N : integer := 6  -- Numero di stadi di divisione (potenze di 2)
    );
    Port (
        clk_in    : in  STD_LOGIC;
        sel: in std_logic_vector (2 downto 0);
        reset     : in  STD_LOGIC;
        clk_div   : out STD_LOGIC  -- Uscite di divisione
    );
end component prescaler;
signal prsc2cnt: std_logic;
type timer_register  is array (1 downto 0) of std_logic_vector (31 downto 0);
signal timer_reg: timer_register := (others=>(others=>'0'));
signal int_flag_sig: std_logic;
begin
register_process: process(clk)
begin
    if rising_edge (clk) then
        if reset = '1' then 
            timer_reg <= (others => (others => '0'));
        elsif enable = '1' then 
            timer_reg(TO_INTEGER(unsigned(addr))) <= din;
        end if;
    end if;
end process;
prescaler_map: prescaler port map (
    clk_in => clk,
    reset => reset,
    sel => timer_reg(1)(2 downto 0),
    clk_div => prsc2cnt
);
counter_map: counter port map (
    clk => prsc2cnt,
    reset => reset,
    oc1 => timer_reg(0)(15 downto 0),
    oc2 => timer_reg(0)(31 downto 16),
    hit => int_flag_sig,
    pwm_out => pwm_out
);
int_flag <= int_flag_sig and timer_reg(1)(8);


end Structural;
