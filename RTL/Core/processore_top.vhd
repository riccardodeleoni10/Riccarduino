----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.02.2025 15:28:23
-- Design Name: 
-- Module Name: processore_top - Behavioral
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

entity processore_top is
      generic (
        INSTR_LENGTH: integer := 32
      );
      Port ( 
        clk,reset : in std_logic;
        Instr_mem_data: in std_logic_vector (INSTR_LENGTH -1 downto 0);
        Instr_mem_addr: out std_logic_vector (12 downto 0);
        N: out std_logic;
        int_flag,pwm_out: out std_logic
      );
end processore_top;

architecture Behavioral of processore_top is
component alu is
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
end component alu;
component control_unit is
      Port ( 
        OP_code: in std_logic_vector (6 downto 0);
        F3: in std_logic_vector (2 downto 0);
        F7_5,Z: in std_logic;
        RESctrl: out std_logic_vector(1 downto 0);
        ALUctrl: out std_logic_vector(3 downto 0);
        ALUsrc : out std_logic;
        EXTctrl:out std_logic_vector (1 downto 0);
        REGwe: out std_logic;
        DMwe: out std_logic;
        DMsrc : out std_logic;
        LRUctrl : out std_logic_vector (2 downto 0);
        PCsrc: out std_logic;
        SRUctrl: out std_logic_vector (1 downto 0)
      );
end component control_unit;
component addresse_decoding is
      generic (
        dm_location: integer :=9;
        timer_location: integer:= 2 -- per ora solo questo
      )
      ;
      Port ( 
        mem_write: in std_logic;
        addr_in: in std_logic_vector (31 downto 0);
        write_vector: out std_logic_vector (1 downto 0);
        addr_out: out std_logic_vector (31 downto 0)
        );
end component addresse_decoding;
component Timer is
      Port ( 
        addr : in std_logic_vector(31 downto 0);
        clk,reset,enable: in std_logic;
        din: in std_logic_vector(31 downto 0);
        int_flag,pwm_out : out std_logic
      );
end component Timer;
component data_memory is
      generic (
            DATA_WIDTH: integer := 32;
            RAM_DEPTH: integer := 10
      );
      Port ( 
        reset,clk,we,WAsrc: in std_logic;
       -- byte_ctrl: in std_logic_vector (1 downto 0); 
        addr,wd: in std_logic_vector (DATA_WIDTH-1 downto 0);
        rd: out std_logic_vector (DATA_WIDTH -1 downto 0)
      );
end component;
component  extend_unit is
      Port ( 
        instr : in std_logic_vector (31 downto 7);
        EXTctrl: in std_logic_vector (1 downto 0);
        EXTout: out std_logic_vector (31 downto 0)
      );
end component extend_unit;
component program_counter is 
generic (
        N_BIT: integer := 13
    );
     Port ( 
        clk,reset,PCsrc : std_logic;
        pc_branch : in std_logic_vector (N_BIT-1 downto 0);
        pc_t: out std_logic_vector(N_BIT-1 downto 0)
     );
end component program_counter;
component register_file is
    generic (
            N_BIT: integer:=32;
            N_REG: integer:=32;
            ADDR_WIDHT: integer:=5
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
end component register_file;
component load_result_unit is
      generic (
        N_BIT: integer := 32
      );
      Port ( 
        din : in std_logic_vector (N_BIT-1 downto 0);
        LRUctrl: in std_logic_vector (2 downto 0);
        dout: out std_logic_vector (N_BIT -1 downto 0)
      );
end component load_result_unit;
component store_result_unit is
      Port ( 
        din: in std_logic_vector (31 downto 0);
        SRUctrl: in std_logic_vector (1 downto 0);
        dout: out std_logic_vector (31 downto 0)
      );
end component store_result_unit;
component result_mux is
      Port ( 
            RESctrl: in std_logic_vector(1 downto 0);
            DMin: in std_logic_vector (31 downto 0);
            ALUin: in std_logic_vector (31 downto 0);
            PCin: in std_logic_vector (12 downto 0);
            Result: out std_logic_vector (31 downto 0)
      );
end component result_mux;
component pc_alu is
      Port ( 
        pc : in std_logic_vector (12 downto 0);
        ext: in std_logic_vector (31 downto 0);
        pc_branch: out std_logic_vector (12 downto 0)
      );
end component pc_alu;
signal rd2alu1, rd2alu2,ext2alu,alu2mux_res,dm2lru,lru2mux_res,sru2mapIO,res2regfile,addr_dec2mapIO: std_logic_vector (31 downto 0);
signal pcalu2pc,pc_sig : std_logic_vector (12 downto 0);
signal addr_dec2write : std_logic_vector (1 downto 0);
signal z_flag: std_logic;
signal control_bus: std_logic_vector (17 downto 0);
begin

alu_map: alu port map (
    A => rd2alu1,
    B=> rd2alu2,
    EXT => ext2alu,
    ALUctrl => control_bus(3 downto 1),
    ALUchange => control_bus(14),
    ALUsrc => control_bus(4),
    ALUout => alu2mux_res,
    N => N,
    Z => Z_flag
);
control_unit_map: control_unit port map (
    OP_code => instr_mem_data(6 downto 0),
    F3 => instr_mem_data (14 downto 12),
    F7_5 => instr_mem_data(30),
    z => z_flag,
    RESctrl(0)=>control_bus(0),
    RESctrl(1)=> control_bus(17),
    ALUctrl(2 downto 0 )=> control_bus(3 downto 1),
    ALUctrl (3) => control_bus(14),
    ALUsrc=> control_bus(4),
    EXTctrl(0)=> control_bus(5),
    EXTctrl(1) => control_bus(15),
    PCsrc => control_bus(16),
    DMwe => control_bus(6),
    REGwe => control_bus(7),
    DMsrc => control_bus(8),
    LRUctrl => control_bus(11 downto 9),
    SRUctrl => control_bus(13 downto 12)
);
addresse_decoding_map : addresse_decoding port map (
        mem_write => control_bus(6),
        addr_in => alu2mux_res,
        write_vector => addr_dec2write,
        addr_out => addr_dec2mapIO 
);
timer_map: timer port map (
        addr => addr_dec2mapIO,
        clk  => clk,
        reset => reset ,
        enable => addr_dec2write(1),
        din => sru2mapIO,
        int_flag => int_flag,
        pwm_out => pwm_out 
);
data_memory_map: data_memory port map (
    reset => reset,
    clk => clk,
    we => addr_dec2write(0),
    addr => addr_dec2mapIO,
    wd => sru2mapIO,
    wasrc => control_bus(8),
    rd => dm2lru
);
extend_unit_map: extend_unit port map (
    instr => Instr_mem_data(31 downto 7),
    EXTctrl(0) => control_bus(5),
    EXTctrl(1) => control_bus(15),
    EXTout => ext2alu
);
program_counter_map: program_counter port map (
    clk => clk,
    reset => reset,
    PCsrc => control_bus(16),
    pc_branch => pcalu2pc,
    pc_t=>pc_sig 
);
instr_mem_addr<= pc_sig ;
register_file_map: register_file port map (
    clk => clk,
    reset => reset,
    we3 => control_bus(7),
    wd3 => res2regfile,
    wa3 => instr_mem_data(11 downto 7),
    ra2 => instr_mem_data(24 downto 20),
    ra1 => instr_mem_data(19 downto 15),
    rd1 => rd2alu1,
    rd2 => rd2alu2
);
LRU: load_result_unit port map (
    din => dm2lru,
    LRUctrl => control_bus(11 downto 9),
    dout => lru2mux_res
);
SRU : store_result_unit port map (
    din => rd2alu2,
    SRUctrl => control_bus (13 downto 12),
    dout => sru2mapIO
);
result_mux_map: result_mux port map (
    RESctrl(0) => control_bus(0),
    RESctrl(1) => control_bus(17),
    PCin => pc_sig,
    DMin => lru2mux_res,
    ALUin => alu2mux_res,
    Result => res2regfile
);
pc_alu_map : pc_alu port map (
    
        pc => pc_sig,
        ext => ext2alu,
        pc_branch => pcalu2pc
      );




end Behavioral;
