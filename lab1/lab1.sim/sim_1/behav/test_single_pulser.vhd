----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2016 03:24:35 AM
-- Design Name: 
-- Module Name: test_single_pulser - Behavioral
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

entity test_single_pulser is
end test_single_pulser;

architecture Behavioral of test_single_pulser is
    component single_pulser is
    port (clk : in std_logic;
          sig_in : in std_logic;
          hold : in std_logic;
          slow_clk : in std_logic;
          sig_out : out std_logic);
    end component;
    
    signal clk, sig_in, hold, slow_clk, sig_out : std_logic;
    constant clk_p : time := 100 ns;
    constant clk_s : time := 500 ns;
begin
    uut : single_pulser
    port map (clk => clk, sig_in => sig_in, hold => hold, slow_clk => slow_clk, sig_out => sig_out);
    
    clk_proc : process    
    begin
        clk <= '0';
        wait for clk_p / 2;
        clk <= '1';
        wait for clk_p / 2;
    end process;
    
    clk_slow_proc : process
    begin
        slow_clk <= '0';
        wait for clk_s / 2;
        slow_clk <= '1';
        wait for clk_s / 2;
    end process; 
    
    sim_sig_in : process
    begin
        sig_in <= '0';
        wait for clk_p * 2;
        sig_in <= '1'; 
        wait for clk_p * 1.5;
        sig_in <= '0';
        wait for clk_p * 10;
        
        sig_in <= '1';
        wait for clk_p * 2;
        sig_in <= '0';
        wait for clk_p * 1.5;
        sig_in <= '1';
        wait for clk_p * 3;
        sig_in <= '0';
        wait for clk_s * 1.5;
        sig_in <= '1';
        wait for clk_p * 3;
        sig_in <= '0';
        wait;        
    end process;
    
    sim_hold : process
    begin
        hold <= '0';
        wait for clk_p * 10;
        hold <= '1';
        wait for clk_s * 20;
        hold <= '0';
        wait;
    end process;
    
end Behavioral;
