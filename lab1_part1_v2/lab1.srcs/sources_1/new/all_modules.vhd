----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2016 17:20:37
-- Design Name: 
-- Module Name: all_modules - Behavioral
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

entity all_modules is
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
end all_modules;

architecture Behavioral of all_modules is

               component counter
               Port ( 
                    clk : in STD_LOGIC;
                    clk_slow_1hz: in STD_LOGIC;
                    dir : in STD_LOGIC;
                    mode: in STD_LOGIC;
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
               component clock_divider_1hz
                   Port ( clk : in STD_LOGIC;
                      clk_slow_1hz : out STD_LOGIC);
               end component;
      signal count_dir,clk_slow_1hz, load_dir, filtered_tick,mode,one_pulse_debounced_press_button_tick, debounced_press_button_load,mode_dir_toggle_debounced_press_button_mode, count_dir_toggle_debounced_press_button_count: std_logic:='0';
begin
            --tick <= filtered_tick or mode_dir;
    refined_all_inputs: debounced_button port map(
        clk => clk,
        raw_press_button_count => raw_press_button_count,
        raw_press_button_load => raw_press_button_load,
        raw_press_button_mode => raw_press_button_mode,
        raw_press_button_tick => raw_press_button_tick,
        count_dir_toggle_debounced_press_button_count => count_dir_toggle_debounced_press_button_count,
        mode_dir_toggle_debounced_press_button_mode => mode_dir_toggle_debounced_press_button_mode,
        debounced_press_button_load => debounced_press_button_load,
        one_pulse_debounced_press_button_tick => one_pulse_debounced_press_button_tick
    );
    counter2 : counter port map(
        clk => clk,
        clk_slow_1hz => clk_slow_1hz,
        dir => count_dir_toggle_debounced_press_button_count,
        mode=>mode_dir_toggle_debounced_press_button_mode,
        en => one_pulse_debounced_press_button_tick,
        load => debounced_press_button_load,
        dip0 => dip0,
        dip1 => dip1,
        dip2 => dip2,
        dip3 => dip3,
        count => count
    );
    clk_1hz : clock_divider_1hz port map(
    clk => clk,
    clk_slow_1hz => clk_slow_1hz
    );
            
end Behavioral;
