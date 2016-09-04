----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2016 15:45:04
-- Design Name: 
-- Module Name: enable_counter - Behavioral
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

entity enable_counter is
    Port(
        
    );
end enable_counter;

architecture Behavioral of enable_counter is

    component toggle_button
Port ( pressed : in STD_LOGIC;
           dir : out STD_LOGIC);
           end component;
           
           component clk_filter 
           Port(
               
           );
begin


end Behavioral;
