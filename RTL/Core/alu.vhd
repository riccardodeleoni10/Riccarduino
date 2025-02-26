----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2025 19:43:39
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
      generic (
        N_BIT : integer := 32
      );
      Port (
        A,B,EXT: in std_logic_vector (N_BIT -1 downto 0);
        ALUctrl: in std_logic_vector(2 downto 0);
        ALUchange: in std_logic;
        ALUsrc : in std_logic;
        ALUout: out std_logic_vector (N_BIT-1 downto 0);
        Z,N : out std_logic
       );
end alu;
--RISCV OPERATION ENCODING
--add := "000"
--sub := "001"
--or := "011"
--and := "010"
--slt := "101"
--shift :="100" questa la aggiungo io
--abs:="110" valore assoluto

architecture Behavioral of alu is
signal mux2alu,add_sub2mux,or2mux,and2mux,slt2mux,sll2mux,srl_sra2mux,ALUout_sig,xor2mux: std_logic_vector (N_BIT-1 downto 0);
signal z_sig,n_sig : std_logic;
begin
srcB_mux: process(ALUsrc,B,EXT)
begin
    if ALUsrc = '0' then 
         mux2alu<= EXT;
        else mux2alu <= B;
    end if;
end process;
add_sub: process(A,mux2alu,ALUchange)
variable cin: std_logic_vector (N_BIT-1 downto 0);
begin
    if ALUchange = '0' then             -- sum
           add_sub2mux<= std_logic_vector(unsigned( A) + unsigned(mux2alu));
    else 
        cin := (31 downto 1 => '0') & ALUchange;    --sub
        add_sub2mux<= A + not (mux2alu) + cin;
    end if;
end process;
xor_op : process (a,mux2alu)
begin
    xor2mux<= A xor mux2alu;
end process;
or_op:process(A,mux2alu)
begin
    or2mux<= A or mux2alu;
end process;
and_op: process(A,mux2alu)
begin
    and2mux<= A and mux2alu;
end process;
slt: process(A,mux2alu)
variable zeros : std_logic_vector (N_BIT -2 downto 0):= x"0000000" & "000";
begin
    if A < mux2alu then slt2mux<= zeros & '1';
    else slt2mux <= zeros & '0';
    end if;
end process;
shift_left_logical: process(A,mux2alu)
variable shifter: integer range 0 to 32;
variable to_shift: unsigned (N_BIT-1 downto 0);
begin
    shifter := TO_INTEGER(unsigned (mux2alu(4 downto 0)));
    to_shift := unsigned (A);
    sll2mux <= std_logic_vector(shift_left(to_shift,shifter));
end process;
srl_sra: process(A,mux2alu,ALUchange)
variable to_shift_logic: unsigned (N_BIT-1 downto 0);
variable to_shift_arith: signed (N_BIT -1 downto 0);
variable shifter: integer range 0 to 32;
begin
    to_shift_logic := unsigned (A);
    shifter := TO_INTEGER(unsigned(mux2alu(4 downto 0)));
    to_shift_arith := signed (A);
    if ALUchange = '0' then                     --shift right logica
        srl_sra2mux<= std_logic_vector(shift_right(to_shift_logic,shifter));
    else 
        srl_sra2mux<= std_logic_vector(shift_right(to_shift_Arith,shifter)); -- shift right aritmetico
   end if;
end process;
alu_mux: process(add_sub2mux,xor2mux,or2mux,and2mux,slt2mux,sll2mux,srl_sra2mux,ALUctrl)
begin
    case ALUctrl is
        when "000" => ALUout_sig<= add_sub2mux;
        when "001" => ALUout_sig<= xor2mux;
        when "010" => ALUout_sig<= and2mux;
        when "011" => ALUout_sig <= or2mux;
        when "100" => ALUout_sig<= sll2mux;
        when "101" => ALUout_sig <= slt2mux;
        when "110" => ALUout_sig <= srl_sra2mux;
        when others => ALUout_sig <= (others =>'-'); -- condizione di don't care
       
    end case;
end process;
flag_generator: process(ALUout_sig)
variable temp,curr: std_logic;
constant zeros : std_logic_vector (N_BIT-1 downto 0) := x"00000000";
begin
    temp := '1';
   for i in 0 to 31 loop
    curr := zeros(i) nor ALUout_sig(i);
    temp := temp and curr;
    end loop;
    Z_sig<= temp;
   N_sig<=ALUout_sig(N_BIT-1);
end process;
flag_out: process(z_sig,n_sig)
begin
    if z_sig = '1' then z <= z_sig;
        else z <= '0';
    end if;
    if n_sig = '1' then n <= n_sig;
        else n<= '0';
   end if;
end process;
ALUout<= ALUout_sig;
end Behavioral;
