----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2016 10:38:38 AM
-- Design Name: 
-- Module Name: key_test - Behavioral
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

entity key_test is
end key_test;

architecture Behavioral of key_test is

component expander is port (
       clk : in STD_LOGIC;
       op : in STD_LOGIC;
       keyIn : in STD_LOGIC_VECTOR (127 downto 0);
       fin : out STD_LOGIC;
       keyNum : out STD_LOGIC_VECTOR (3 downto 0);
       keyOut : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
    
    signal clk, op, fin : std_logic;
    signal keyNum : std_logic_vector (3 downto 0);
    signal keyIn, keyOut : std_logic_vector (127 downto 0);
    constant clk_p : time := 100 ns; 
begin
    uut : expander port map (
        clk => clk,
        op => op,
        keyIn => keyIn,
        fin => fin,
        keyNum => keyNum,
        keyOut => keyOut);
    
    clk_proc : process
    begin
        clk <= '0';
        wait for clk_p / 2;
        clk <= '1';
        wait for clk_p / 2;
    end process;
                
    simu_proc : process
        begin
            op <= '0';
            wait for clk_p;
            op <= '1';
            keyIn <= x"00000000000000000000000000000000";
            wait for 20 * clk_p;
            keyIn <= x"000102030405060708090a0b0c0d0e0f";
            wait for clk_p;
            op <= '0';
            wait for clk_p;
            op <= '1';
            wait for clk_p * 20;
            op <= '0';                                    
            wait;
        end process;

end Behavioral;
