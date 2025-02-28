library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity prescaler is
    generic (
        N : integer := 6  -- Numero di stadi di divisione (potenze di 2)
    );
    Port (
        clk_in    : in  STD_LOGIC;
        sel: in std_logic_vector (2 downto 0);
        reset     : in  STD_LOGIC;
        clk_div   : out STD_LOGIC  -- Uscite di divisione
    );
end prescaler;

architecture Behavioral of prescaler is
    signal q : STD_LOGIC_VECTOR(N downto 0) := (others => '0');
begin
    -- Il primo elemento è il clock di ingresso
    q(0) <= clk_in;
    -- Genera gli stadi di flip-flop usando generate
    gen_stages: for i in 1 to N generate
        process(q(i-1), reset)
        begin
            if reset = '1' then
                q(i) <= '0';
            elsif rising_edge(q(i-1)) then
                q(i) <= not q(i);
            end if;
        end process;
    end generate;
    -- Assegna le uscite
  
mux_out:process(q,sel)
begin 
    if sel <= N then 
        clk_div<= q(TO_INTEGER (unsigned(sel)));
    else clk_div <= q (0);
    end if;
    
end process;    
end Behavioral;