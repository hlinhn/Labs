----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.08.2016 18:31:55
-- Design Name: 
-- Module Name: debounced_toggle_button - Behavioral
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

entity debounced_toggle_button is
    Port ( press : in STD_LOGIC;
           refined_press : out STD_LOGIC;
           clk : in STD_LOGIC;
           clk_slow : in STD_LOGIC);
end debounced_toggle_button;

architecture Behavioral of debounced_toggle_button is
    component debounce
    Port ( press : in STD_LOGIC;
           refined_press : out STD_LOGIC;
           clk : in STD_LOGIC;
           clk_slow : in STD_LOGIC);
end component;
begin


end Behavioral;
