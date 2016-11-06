----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 12:48:57 PM
-- Design Name: 
-- Module Name: decryptor - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decryptor is
    Port ( clk : in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           load_key : in STD_LOGIC;
           mes : in STD_LOGIC_VECTOR (127 downto 0);
           mesOut : out STD_LOGIC_VECTOR (127 downto 0));
end decryptor;

architecture Behavioral of decryptor is
    component expander is port (
           clk : in STD_LOGIC;
           op : in STD_LOGIC;
           keyIn : in STD_LOGIC_VECTOR (127 downto 0);
           fin : out STD_LOGIC;
           keyNum : out STD_LOGIC_VECTOR (3 downto 0);
           keyOut : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    component memory is
        generic (N: integer;
                 AS : integer;
                 DL : integer);
        Port ( clk : in STD_LOGIC;
               we : in STD_LOGIC;
               addr : in STD_LOGIC_VECTOR (AS - 1 downto 0);
               dataIn : in STD_LOGIC_VECTOR (DL - 1 downto 0);
               dataOut : out STD_LOGIC_VECTOR (DL * N - 1 downto 0)); 
    end component;
    
    component transformer is 
        Port ( numIn : in STD_LOGIC_VECTOR (127 downto 0);
               roundNum : in STD_LOGIC_VECTOR (3 downto 0);
               key : in STD_LOGIC_VECTOR (127 downto 0);
               numOut : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
           
    type interm is array (natural range 0 to 10) of std_logic_vector (127 downto 0);
    signal inbtwn, outbtwn : interm;
    signal mem : interm;
     
    --memory
    signal we : std_logic;
    signal addr, raddr : std_logic_vector (3 downto 0);
    signal dataIn : std_logic_vector (127 downto 0);
    signal dataOut : std_logic_vector (1407 downto 0);
    
    --key expander
    signal op, fin, old_load : std_logic := '0';
    signal keyNum : std_logic_vector (3 downto 0);
    signal keyOut : std_logic_vector (127 downto 0);
    
          
begin
    data: 
        for i in 0 to 10 generate
            mem(i) <= dataOut (1407 - i * 128 downto 1280 - i * 128); 
        end generate;
             
    trans:
        for i in 0 to 10 generate
            transforms : transformer port map (
                numIn => inbtwn(i),
                roundNum => std_logic_vector(to_unsigned(i, 4)),
                key => mem(10 - i),
                numOut => outbtwn(i)
            );
        end generate;        
                  
    addr <= keyNum when we = '1' else "0000";
    dataIn <= keyOut;
    
    process (clk)
    variable keyIn : std_logic;
    begin        
        if clk'event and clk = '1' then
            if load_key = '1' and old_load = '0' then
                keyIn := '1';
            else 
                keyIn := '0';
            end if;
            
            inbtwn(0) <= mes;
            for i in 0 to 9 loop
                inbtwn(i + 1) <= outbtwn(i);
            end loop;
            mesOut <= outbtwn(10);
                                     
            old_load <= load_key;    
            op <= not keyIn;
            we <= not keyIn;          
        end if;
    end process;
    
    key_mem : memory generic map (N => 11, AS => 4, DL => 128) 
        port map (
        clk => clk,
        we => we,
        addr => addr,
        dataIn => dataIn,
        dataOut => dataOut);
    
    key_expander : expander port map (
        clk => clk,
        op => op,
        keyIn => key,
        fin => fin,
        keyNum => keyNum,
        keyOut => keyOut);
            
end Behavioral;
