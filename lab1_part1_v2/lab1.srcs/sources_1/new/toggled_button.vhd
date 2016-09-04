----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2016 16:26:56
-- Design Name: 
-- Module Name: toggle_button - Behavioral
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

entity toggled_button is
    Port ( pressed : in STD_LOGIC; --expects a debounced press;
            clk : in STD_LOGIC;
           dir : out STD_LOGIC);
end toggled_button;

architecture Behavioral of toggled_button is

begin
process(clk)

variable curr_dir,old_press: std_logic:='0';
begin
    if(clk'event and clk='1') then
        if(pressed ='1' and old_press = '0') then
            --if(prev_press = '0') then
            curr_dir := not curr_dir; --toggle previous direction
              --set as current direction. 
            --prev_press := '1';
            
        end if;
        old_press:=pressed;
    dir <= curr_dir;
    end if;
end process;
    

end Behavioral;
