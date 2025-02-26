----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2025 21:38:57
-- Design Name: 
-- Module Name: data_memory - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
      generic (
            DATA_WIDTH: integer := 32;
            RAM_DEPTH: integer := 64
      );
      Port ( 
        reset,clk,we,WAsrc: in std_logic;
       -- byte_ctrl: in std_logic_vector (1 downto 0); 
        addr,wd: in std_logic_vector (DATA_WIDTH-1 downto 0);
        rd: out std_logic_vector (DATA_WIDTH -1 downto 0)
      );
-- l'indirizzo addr non codifica tutti gli indirizzi della RAM, che sono di meno,
-- ha questa dimensione fissa perchè è la dimensione del dato che esce dall'ALU
end data_memory;

architecture Behavioral of data_memory is
type ram_type is array  (RAM_DEPTH -1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
signal dm: ram_type := (others=>(others => '0'));
signal mux2ram: std_logic_vector (DATA_WIDTH -1 downto 0);
--signal data_mem_out: std_logic_vector(DATA_WIDTH -1 downto 0);
begin
mux_in: process(addr,WASrc)
begin
    if WAsrc = '1' then mux2ram<=addr;
    else mux2ram <= (others => '0');
    end if;
end process;
ram_process: process(clk)
begin
    if rising_edge (clk) then 
        if reset = '1' then
                             dm <= (others => (others => '0'));
                            rd <= (others => '0');
        else 
            if we = '1' then dm(TO_INTEGER(unsigned(mux2ram))) <= wd;
        end if;
    end if;
    end if;
     rd <= dm(TO_INTEGER(unsigned (mux2ram)));
end process;
--byte_mask_process: process(data_mem_out,byte_ctrl)
--constant mask_b: std_logic_vector(DATA_WIDTH -1 downto 0) :=x"000000FF";
--constant mask_hw: std_logic_vector (DATA_WIDTH -1 downto 0) := x"0000FFFF";
--begin
  --  case byte_ctrl is 
    --    when "00" => rd<= data_mem_out;
      --  when "01" => rd <= data_mem_out and mask_hw;
        --when others => rd <= data_mem_out and mask_b;
    --end case;
--end process;
end Behavioral;
