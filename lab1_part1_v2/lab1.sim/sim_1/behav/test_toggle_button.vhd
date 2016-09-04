----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2016 16:45:56
-- Design Name: 
-- Module Name: test_toggle_button - Behavioral
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

entity test_toggle_button is
end test_toggle_button;

architecture Behavioral of test_toggle_button is
component toggle_button is
       Port ( 
       pressed : in STD_LOGIC;
       clk: in STD_LOGIC;
       dir : out STD_LOGIC
       );
    end component;
    
    signal clk,pressed,dir : std_logic := '0';
    constant clk_period : time := 10ns;
begin
        uut: toggle_button port map (
            pressed => pressed,
            dir => dir,
            clk => clk
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
                   pressed <= '1'; 
                   wait for 500 ns;
                    pressed <= '0';
                    wait for 120 ns;
                    pressed <= '1';
                    wait for 100 ns;
                    pressed <= '0';
                    wait for 120 ns;
                    pressed <= '1';
                   wait;
               end process;

end Behavioral;
