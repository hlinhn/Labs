----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.08.2016 14:59:33
-- Design Name: 
-- Module Name: test_clk_filter - Behavioral
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

entity test_clk_filter is
end test_clk_filter;

architecture Behavioral of test_clk_filter is

component clk_filter is
Port ( btn : in STD_LOGIC;
            clk : in STD_LOGIC;
           filtered_btn : out STD_LOGIC);
           
            
 end component;
 
 signal btn,clk, filtered_btn : std_logic := '0';
 constant clk_period : time := 100ns;
 
begin
 uut: clk_filter port map (
       btn => btn,
       clk => clk,
       filtered_btn => filtered_btn
      );

 clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;
    
    stim_process : process
        begin
            wait for 120 ns;
            btn <= '0';
            wait for 200 ns;
            btn <= '1';
            wait for 200 ns;
            btn <= '0';
            wait for 200 ns;
            btn <= '1';
            wait for 3000 ns;
            wait;
        end process;
        
end Behavioral;