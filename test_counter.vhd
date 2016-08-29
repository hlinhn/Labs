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
          count : out std_logic_vector(3 downto 0)
          );
    end component;
    
    signal dir, clk : std_logic := '0';
    signal count : std_logic_vector(3 downto 0) := "0000";
    
    constant clk_period : time := 100ns;
begin
    uut: counter port map (
        dir => dir,
        clk => clk,
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
        wait for 120 ns;
        dir <= '1';
        wait for 500 ns;
        dir <= '0';
        wait for 2000 ns;
        dir <= '1';
        wait for 3000 ns;
        dir <= '0';
        wait for 20 ns;
        dir <= '1';
        wait for 50 ns;
        dir <= '0';
        wait;
    end process;
   

end Behavioral;
