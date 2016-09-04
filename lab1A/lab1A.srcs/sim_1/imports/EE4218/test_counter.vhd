----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/24/2016 09:36:19 AM
-- Design Name: 
-- Module Name: test_counter - Behavioral
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

entity test_counter is
end test_counter;

architecture Behavioral of test_counter is
    component counter is
    port (clk : in std_logic;
          dir : in std_logic;
          load : in std_logic;
          mode : in std_logic;
          tick : in std_logic;
          num : in std_logic_vector (3 downto 0);
          count : out std_logic_vector(3 downto 0)
          );
    end component;
    
    signal dir, clk, load, mode, tick : std_logic := '0';
    signal count, num : std_logic_vector(3 downto 0) := "0000";
    
    constant clk_period : time := 100ns;
    constant clk_p : time := 800ns;
    constant clk_1hz : time := 6400ns;
begin
    uut: counter port map (
        dir => dir,
        clk => clk,
        load => load,
        mode => mode,
        tick => tick,
        num => num,
        count => count
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
        mode <= '0';
        tick <= '0';
        load <= '0';
        num <= "1001";
        wait for clk_period;
        dir <= '1';
        wait for 2 * clk_p;
        dir <= '0';
        wait for 2 * clk_1hz;
        dir <= '1';
        wait for 3 * clk_1hz;
        dir <= '0';
        wait for 20 ns;
        dir <= '1';
        wait for 50 ns;
        dir <= '0';
        wait for clk_p;
        dir <= '1';
        wait for 3 * clk_p;
        dir <= '0';
        wait for 5 * clk_1hz;
        dir <= '1';
        wait for 5 * clk_1hz;        
        dir <= '0';
        
        load <= '1';
        wait for 5 * clk_p;
        num <= "1111";
        wait for 2 * clk_1hz;
        load <= '0';
        wait for 3 * clk_1hz;
        load <= '1';
        wait for 3 * clk_p;
        load <= '0';
        
        mode <= '1';
        wait for 5 * clk_p;
        mode <= '0';
        tick <= '1';
        wait for 5 * clk_p;
        tick <= '0';
        wait for 6 * clk_1hz;
        tick <= '1';
        wait for 6 * clk_p;
        tick <= '0';
        wait for clk_period;
        tick <= '1';
        wait for 7 * clk_p;
        tick <= '0';
        wait for 3 * clk_1hz;
        tick <= '1';
        wait for 4 * clk_p;
        tick <= '0';
        mode <= '1';
        wait for 4 * clk_p;
        mode <= '0';
        wait for 6 * clk_1hz;
        mode <= '1';
        dir <= '1';
        wait for 5 * clk_p;
        dir <= '0';
        mode <= '0';
        wait for 10 * clk_1hz;
        tick <= '1';
        wait for 5 * clk_p;
        tick <= '0';
        wait for 10 * clk_p;
        tick <= '1';
        wait for 15 * clk_p;
        tick <= '0';
        
        wait for 5 * clk_p;
        tick <= '1';
        wait for 6 * clk_p;
        tick <= '0';        
        wait for 6 * clk_p;
        tick <= '1';
        wait for 6 * clk_p;
        tick <= '0';        
        wait;
    end process;
   

end Behavioral;
