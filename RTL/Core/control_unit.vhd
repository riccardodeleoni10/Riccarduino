----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.02.2025 11:56:21
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
      Port ( 
        OP_code: in std_logic_vector (6 downto 0);
        F3: in std_logic_vector (2 downto 0);
        F7_5,Z: in std_logic;
        RESctrl: out std_logic_vector(1 downto 0);
        ALUctrl: out std_logic_vector(3 downto 0);
        ALUsrc : out std_logic;
        EXTctrl:out std_logic_vector (1 downto 0);
        PCsrc : out std_logic;
        REGwe: out std_logic;
        DMwe: out std_logic;
        DMsrc: out std_logic;
        LRUctrl: out std_logic_vector (2 downto 0);
        SRUctrl: out std_logic_vector (1 downto 0)
      );
end control_unit;

architecture Behavioral of control_unit is
signal ctrl_bus : std_logic_vector (10 downto 0); 
--ctrl_bus assigment:PCsrc,RESctrl1,RESctrl0,ALUop1(vedi ALU_decoder),ALUop0,ALUsrc,EXTctrl_1,EXTctrl_0,REGwe,DMwe,DMsrc
signal ALU_op: std_logic_vector (1 downto 0) ;
signal F_bus : std_logic_vector(3 downto 0);
signal Fbus_3: std_logic;
signal branch_opt: std_logic;
begin

F_bus<=Fbus_3 & F3;
-- per ora gestiamo lw-sw-R operations
main_deocoder: process(OP_code,Z,F3)
begin
    case OP_code is 
        when "0000011" => ctrl_bus<="00000000101"; --l
        when "0100011" => ctrl_bus<="00000001011";--s
        when "0110011" => ctrl_bus<="001011--100"; --R-Type
        when "0010011" => ctrl_bus<="00101000100";-- I-Type
        when "1100011" => ctrl_bus<="10010110000"; -- B-Type
        when "1101111" => ctrl_bus<= "110---11100"; --J-Type
        when others => ctrl_bus<= (others => '-');--don't care
    end case;
end process;
ALU_op<=ctrl_bus(7 downto 6);
function_bus: process (F3,F7_5,op_code)
begin
    if op_code = "0010011" and F3 = "101" 
        then Fbus_3 <= f7_5;
   else Fbus_3 <= F7_5 and op_code (5);
   end if;
end process;
alu_decoder: process(ALU_op,F_bus)
begin
    case ALU_op is 
        when "00" =>  ALUctrl<="0000"; -- l,s
        when "01" =>  case F_bus is -- r-type
                        when "0000" => ALUctrl <= "0000"; --add
                        when "1000" => ALUctrl <= "1000" ; -- sub
                        when "-010" => ALUctrl <= "0101";-- slt
                        when "-110" => ALUctrl <= "0011"; --or
                        when "-111" => ALUctrl <= "0010"; -- and
                        when "-100" => ALUctrl <= "0001"; -- xor
                        when "-001" => ALUctrl <= "0100"; --sll
                        when "0101" => ALUctrl <= "0110"; -- srl
                        when "1101" => ALUctrl <= "1110"; -- sra
                        when others => ALUctrl <= "----";
                    end case;  
        when "10" => ALUctrl <= "1000"; -- b-type,basta fare una sottrazione;
                     case F_bus is 
                        when "-000" => branch_opt <= '0'; --beq
                        when "-001" => branch_opt <= '1'; --bne
                        when others => branch_opt <= '-';
                     end case;
        when others => ALUctrl <= (others => '-');
    end case;
end process;
branch_process: process (ctrl_bus(10),z,branch_opt)
begin
    if ctrl_bus(10) = '1' then 
        if branch_opt = '0' then pcsrc <= z;
        else pcsrc <= not(z);
        end if;
    else pcsrc <= '0';
    end if;
end process;

SRUctrl <= F3(1 downto 0);
LRUctrl<= F3;
RESctrl <=ctrl_bus(9 downto 8);
ALUsrc<=ctrl_bus(5);
EXTctrl<=ctrl_bus(4 downto 3);
REGwe<=ctrl_bus(2);
DMwe<=ctrl_bus(1);
DMsrc <= ctrl_bus(0);

end Behavioral;
