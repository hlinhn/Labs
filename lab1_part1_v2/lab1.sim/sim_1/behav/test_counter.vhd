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
    port (
            clk : in STD_LOGIC;
            clk_slow_1hz: in STD_LOGIC;
            dir : in STD_LOGIC;
            en : in STD_LOGIC; -- high speed clk. 
            load : in STD_LOGIC;
            
            dip0 : in STD_LOGIC;
            dip1 : in STD_LOGIC; 
            dip2 : in STD_LOGIC;
            dip3 : in STD_LOGIC;
            tick: out STD_LOGIC;
            count : out STD_LOGIC_VECTOR (3 downto 0)
          );
    end component;
    
    signal dir,en, clk,clk_slow_1hz, load,dip0,dip1,dip2,dip3 : std_logic := '0';
    
    signal count : std_logic_vector(3 downto 0) := "0000";
    
    constant clk_period : time := 10ns;
    constant clkk_period : time := 100ns;
begin
    uut: counter port map (
        dir => dir,
        clk => clk,
        clk_slow_1hz => clk_slow_1hz,
        en => en,
        load => load,
        
        count => count,
        dip0 => dip0,
        dip1 => dip1,
        dip2 => dip2,
        dip3 => dip3
       );
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;
    clk_process2 : process
        begin
            clk_slow_1hz <= '0';
            wait for (9 * clkk_period) / 10;
            clk_slow_1hz <= '1';
            wait for (clkk_period) / 10;
        end process;
        
    stim_process : process
    begin
        wait for 120 ns;
        dir <= '1'; 
        en <='1';
        load <= '1';
        dip0 <= '0';
        dip1 <= '1';
        dip2 <= '1';
        dip3 <= '1';
        wait for 100 ns;
        wait for 500 ns;
        dir <= '0'; en <='0';load <= '0';
        wait for 500 ns;
                dir <= '0'; en <='1';
        wait for 500 ns;
        dir <= '1'; en <='1';
        wait for 3000 ns;
        dir <= '0'; en <='0';
        wait for 20 ns;
        dir <= '1';
        wait for 50 ns;
        dir <= '0';
        wait;
    end process;
   

end Behavioral;
