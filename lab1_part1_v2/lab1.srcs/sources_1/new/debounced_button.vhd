----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.08.2016 20:23:07
-- Design Name: 
-- Module Name: debounced_button - Behavioral
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

entity debounced_button is
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
end debounced_button;

architecture Behavioral of debounced_button is
    component clock_divider
        Port ( clk : in STD_LOGIC;
               clk_slow : out STD_LOGIC);
    end component;
    
    component debounce
        Port ( press : in STD_LOGIC;
               refined_press : out STD_LOGIC;
               clk : in STD_LOGIC
              );
    end component;
    
    component clk_filter
            Port ( 
            btn : in STD_LOGIC;
            clk : in STD_LOGIC;
           filtered_btn : out STD_LOGIC
           );
    end component;
    
    component toggle_button
        Port ( pressed : in STD_LOGIC; --expects a debounced press;
            clk : in STD_LOGIC;
           dir : out STD_LOGIC);
    end component;
    
    signal clk_slow1,debounced_press_button_count,debounced_press_button_mode,debounced_press_button_tick : STD_LOGIC :='0';    
begin     
    clock_divider1 : clock_divider port map(
        clk => clk,
        clk_slow => clk_slow1
    );
    
    button_count : debounce port map(
        press=>raw_press_button_count,
        refined_press=>debounced_press_button_count,
        clk=>clk
    );
    
    button_load : debounce port map(
        press=>raw_press_button_load,
        refined_press=>debounced_press_button_load,
        clk=>clk
    );
    button_mode : debounce port map(
        press=>raw_press_button_mode,
        refined_press=>debounced_press_button_mode,
        clk=>clk
    );
        
    button_tick : debounce port map(
       press=>raw_press_button_tick,
       refined_press=>debounced_press_button_tick,
       clk=>clk
    );
    
    tick_PB : clk_filter port map(
       btn => debounced_press_button_tick,
       clk => clk,
       filtered_btn => one_pulse_debounced_press_button_tick                      
    );
    
    count_PB : toggle_button port map(
        pressed => debounced_press_button_count,
        clk => clk,
        dir => count_dir_toggle_debounced_press_button_count
    );            
                
    mode_PB : toggle_button port map(
        pressed => debounced_press_button_mode,
        clk => clk,
        dir => mode_dir_toggle_debounced_press_button_mode
    );                            
   
end Behavioral;
