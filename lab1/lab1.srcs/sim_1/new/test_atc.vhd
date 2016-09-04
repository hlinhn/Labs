----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/02/2016 07:53:05 AM
-- Design Name: 
-- Module Name: test_atc - Behavioral
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

entity test_atc is
end test_atc;

architecture Behavioral of test_atc is
    component atc is
    Port ( clk : in STD_LOGIC;
           plane : in STD_LOGIC_VECTOR (2 downto 0);
           req : in STD_LOGIC;
           acc : out STD_LOGIC_VECTOR (1 downto 0));
    end component;
    
    signal clk, req : std_logic;
    signal plane: std_logic_vector(2 downto 0);
    signal acc : std_logic_vector (1 downto 0);
    constant clk_p : time := 100 ns;
    constant clk_period : time := 400 ns;
    constant clk_period_1hz : time := 6400 ns;
begin
    uut : atc port map (
        clk => clk,
        req => req,
        plane => plane,
        acc => acc);
        
    clk_process: process
    begin
        clk <= '0';
        wait for clk_p / 2;
        clk <= '1';
        wait for clk_p / 2;
    end process;

    sim_process: process
    begin
        req <= '0'; wait for (3 * clk_period);
        plane<="000"; req <= '1'; wait for (3 * clk_period + clk_period_1hz); 
        req <= '0'; wait for (2 * clk_period_1hz); --1 --test reset(light)
        
        plane<="000"; req <= '1'; wait for (3 * clk_period + 0.5 * clk_period_1hz); 
        req <= '0'; wait for (0.5 * clk_period_1hz); --1 --test 3s(light)
        
        plane<="000"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (2 * clk_period_1hz); --0 --test 3s(light)
        
        plane<="001"; req <= '1'; wait for (5 * clk_period); 
        req <= '0'; wait for (2 * clk_period_1hz); --1 --test 3s(heavy)
        
        plane<="001"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (1 * clk_period_1hz); --0 --test 3s(heavy)
        
        plane<="001"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (2 * clk_period_1hz); --1 --reset
        
        plane<="001"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (1 * clk_period_1hz); --0 --test 3s(heavy)//repeated
        
        plane<="000"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (9 * clk_period_1hz); --0 --test 13s (heavy->light)
        
        plane<="000"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (1 * clk_period_1hz); --1 --test 13s (heavy->light)
        
        plane<="000"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (2 * clk_period_1hz); --1 --test (light-light)
        
        plane<="000"; req <= '1'; wait for (3 * clk_period); 
        req <= '0'; wait for (3 * clk_period_1hz); --0 --test (light-light)
        wait; 
    end process;
end Behavioral;
