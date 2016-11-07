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
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           mes : in STD_LOGIC_VECTOR (127 downto 0);
           readReady : out STD_LOGIC;
           dataReady : out STD_LOGIC;
           mesOut : out STD_LOGIC_VECTOR (127 downto 0));
end decryptor;

architecture Behavioral of decryptor is
    component expander is port (
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
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
    signal count, countOut : integer := 0;
     
    --memory
    signal we : std_logic;
    signal addr : std_logic_vector (3 downto 0);
    signal dataIn : std_logic_vector (127 downto 0);
    signal dataOut : std_logic_vector (1407 downto 0);
    
    --key expander
    signal en, rst, fin, old_load : std_logic := '0';
    signal keyNum : std_logic_vector (3 downto 0);
    signal keyOut, key : std_logic_vector (127 downto 0);
          
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
    readReady <= fin;    
    mesOut <= outbtwn(10);
    dataReady <= '1' when count >= 11 and countOut /= 9 else '0';  

    process (clk)
    variable keyIn : std_logic;
    begin        
        if clk'event and clk = '1' then
            case mode is
            when "00" =>
                rst <= '1';
                count <= 0;
                countOut <= 0; 
            when "01" =>
                rst <= '0';
                en <= '1';
                we <= '1';
                key <= mes;
            when "10" =>
                en <= '0';
                we <= '0';
                inbtwn(0) <= mes;                                           
                if count < 11 then
                    count <= count + 1;
                end if;
            when others =>     
                if countOut < 9 then
                    countOut <= countOut + 1;
                end if;        
            end case;
                                            
            for i in 0 to 9 loop
                inbtwn(i + 1) <= outbtwn(i);
            end loop;
                                                               
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
        en => en,
        rst => rst,
        keyIn => key,
        fin => fin,
        keyNum => keyNum,
        keyOut => keyOut);
            
end Behavioral;
