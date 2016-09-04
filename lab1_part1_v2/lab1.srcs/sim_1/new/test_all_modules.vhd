----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2016 20:55:22
-- Design Name: 
-- Module Name: test_all_modules - Behavioral
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

entity test_all_modules is
end test_all_modules;

architecture Behavioral of test_all_modules is

component all_modules
    Port ( 
        clk : in STD_LOGIC;
        raw_press_button_count : in STD_LOGIC;
        raw_press_button_load : in STD_LOGIC;
        raw_press_button_mode : in STD_LOGIC;
        raw_press_button_tick : in STD_LOGIC;
        
        dip0 : in STD_LOGIC;
        dip1 : in STD_LOGIC;
        dip2 : in STD_LOGIC;
        dip3 : in STD_LOGIC;
        count : out STD_LOGIC_VECTOR (3 downto 0);
        tick: out STD_LOGIC
       );
end component;
signal raw_press_button_count, raw_press_button_load,raw_press_button_mode,raw_press_button_tick,clk,dip0,dip1,dip2,dip3,tick: STD_LOGIC :='0';
signal count: STD_LOGIC_VECTOR (3 downto 0):="0000";
 constant clk_period : time := 10ns;
 
begin
uut: all_modules port map (
       clk => clk,
       raw_press_button_count => raw_press_button_count,
       raw_press_button_load => raw_press_button_load,
       raw_press_button_mode => raw_press_button_mode,
       raw_press_button_tick => raw_press_button_tick,
       dip0 => dip0,
       dip1 => dip1,
       dip2 => dip2,
       dip3 => dip3,
       count => count,
       tick =>tick
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
            dip0 <= '0';
            dip1 <= '1';
            dip2 <= '1';
            dip3 <= '1';
            
            wait for 100ns;
            raw_press_button_load <= '1';
            wait for 200ns;
            raw_press_button_load <= '0';
                      
            wait for 100ns;
            raw_press_button_mode <= '1';
            wait for 200ns;
            raw_press_button_mode <= '0';
            
            wait for 5ms;
            raw_press_button_mode <= '1';
            wait for 200ns;
            raw_press_button_mode <= '0';  
                      
            wait for 3ms;
            raw_press_button_tick <= '1';
            wait for 200ns;
            raw_press_button_tick <= '0';
            wait for 5ms;    
            wait for 100ns;
            raw_press_button_count <= '1';
            wait for 200ns;
            raw_press_button_count <= '0';
            
            
            
            
            
            wait;
        end process;
        

end Behavioral;
