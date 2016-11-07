----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2016 01:18:37 AM
-- Design Name: 
-- Module Name: wrapper_test - Behavioral
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

entity wrapper_test is
end wrapper_test;

architecture Behavioral of wrapper_test is
    component decrypt_wrapper is 
        Port ( clk : in STD_LOGIC;
               load_key : in STD_LOGIC;
               endData : in STD_LOGIC;
               numIn : in STD_LOGIC_VECTOR (31 downto 0);
               ready : out STD_LOGIC;
               numOut : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    signal clk, load_key, ready, endData : std_logic;
    signal numIn, numOut : std_logic_vector (31 downto 0);
    constant clkp : time := 100ns;           
    
begin
    uut : decrypt_wrapper port map (
        clk => clk,
        load_key => load_key,
        endData => endData,
        numIn => numIn,
        ready => ready,
        numOut => numOut);
        
    clk_proc : process
    begin
        clk <= '1';
        wait for clkp /2;
        clk <= '0';
        wait for clkp /2;
    end process;    
    
    simu_proc : process
    begin
        load_key <= '1';
        endData <= '0';
        numIn <= x"00000000";
        wait for clkp;
        numIn <= x"00000001";
        wait for clkp;
        numIn <= x"00000002";
        wait for clkp;
        numIn <= x"00000003";
        wait for clkp;
        load_key <= '0';
        wait for clkp;
        
        numIn <= x"00000004";
        wait for clkp;
        numIn <= x"00000005";
        wait for clkp;
        numIn <= x"00000006";
        wait for clkp;
        numIn <= x"00000007";
        wait for clkp;
        
        numIn <= x"00000008";
        wait for clkp;
        numIn <= x"00000009";
        wait for clkp;
        numIn <= x"0000000a";
        wait for clkp;
        numIn <= x"0000000b";
        wait for clkp;
        
        numIn <= x"0000000c";
        wait for clkp;
        numIn <= x"0000000d";
        wait for clkp;
        numIn <= x"0000000e";
        wait for clkp;
        numIn <= x"0000000f";
        wait for clkp;
        
        numIn <= x"00000001";
        wait for clkp;
        numIn <= x"00000002";
        wait for clkp;
        numIn <= x"00000003";
        wait for clkp;
        numIn <= x"0000000f";
        wait for clkp;

        numIn <= x"00000004";
        wait for clkp;
        numIn <= x"00000005";
        wait for clkp;
        numIn <= x"00000006";
        wait for clkp;
        numIn <= x"0000001f";
        wait for clkp;
        
        numIn <= x"00000007";
        wait for clkp;
        numIn <= x"00000008";
        wait for clkp;
        numIn <= x"00000009";
        wait for clkp;
        numIn <= x"0000003f";
        wait for clkp;

        numIn <= x"0000000a";
        wait for clkp;
        numIn <= x"0000000b";
        wait for clkp;
        numIn <= x"0000000c";
        wait for clkp;
        numIn <= x"0000005f";
        wait for clkp;

        numIn <= x"0000000d";
        wait for clkp;
        numIn <= x"0000000e";
        wait for clkp;
        numIn <= x"0000000f";
        wait for clkp;
        numIn <= x"ab00002f";
        wait for clkp * 10;
        endData <= '1';
        wait for clkp * 30;
        
        wait;
                       
    end process;
end Behavioral;
