----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.08.2016 19:58:38
-- Design Name: 
-- Module Name: test_debounce - Behavioral
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

entity test_debounced_button is
--  Port ( );
end test_debounced_button;

architecture Behavioral of test_debounced_button is
component debounced_button
    Port ( 
        clk : in STD_LOGIC;
        raw_press_button_count : in STD_LOGIC;
        raw_press_button_load : in STD_LOGIC;
        raw_press_button_mode : in STD_LOGIC;
        raw_press_button_tick : in STD_LOGIC;
        
        count_dir_toggle_debounced_press_button_count : out STD_LOGIC;
        mode_dir_toggle_debounced_press_button_mode : out STD_LOGIC;
        debounced_press_button_load : out STD_LOGIC;
        one_pulse_debounced_press_button_tick : out STD_LOGIC
    );
    
end component;
    signal clk,
    raw_press_button_count,
    raw_press_button_load,
    raw_press_button_mode,
    raw_press_button_tick,
    count_dir_toggle_debounced_press_button_count,
    mode_dir_toggle_debounced_press_button_mode,
    debounced_press_button_load,
    one_pulse_debounced_press_button_tick: STD_LOGIC := '0';
    
    constant clk_period : time := 10ns;
begin
      uut: debounced_button port map(
        clk=>clk,
        raw_press_button_count=>raw_press_button_count,
        raw_press_button_load=>raw_press_button_load,
        raw_press_button_mode=>raw_press_button_mode,
        raw_press_button_tick=>raw_press_button_tick,
        count_dir_toggle_debounced_press_button_count=>count_dir_toggle_debounced_press_button_count,
        mode_dir_toggle_debounced_press_button_mode=>mode_dir_toggle_debounced_press_button_mode,
        debounced_press_button_load => debounced_press_button_load,
        one_pulse_debounced_press_button_tick => one_pulse_debounced_press_button_tick
      );
      
clk_process : process
               begin
                   clk <= '0';
                   wait for clk_period / 2;
                   clk <= '1';
                   wait for clk_period / 2;
               end process;

process begin

   wait for 50ns;
    raw_press_button_count <= '1';
     wait for 100ns;
     raw_press_button_count <= '0';
     
    wait for 50ns;
         raw_press_button_load <= '1';
          wait for 100ns;
          raw_press_button_load <= '0';
          
          wait for 50ns;
                   raw_press_button_tick <= '1';
                    wait for 100ns;
                    raw_press_button_tick <= '0';
                    wait;
end process;
end Behavioral;
